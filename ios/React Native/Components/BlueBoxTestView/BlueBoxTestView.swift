

import Foundation


class BlueBoxTestView: UIView {
  
  // MARK: React Props
  
  // holds the shared bridge instance
  var bridge: RCTBridge!;
  
  // overriding the nativeID property defined from UIView+React so i can
  // listen when the property is being set. Note, there is also a corresponding setter
  // defined in objc, but it cannot be overriden (bc it's not defined in the superview).
  // that's why i can't create a @objc func setNativeID setter.
  override var nativeID: String! {
    didSet {
      print("BlueBoxTestView, didSet prop nativeID: \(nativeID ?? "N/A")");
    }
  };
  
  // MARK: Swift Properties
  
  var testView: UIView!;
  var myButton: UIButton!;
  
  var reactSubview: UIView?;
  
  // we're going to use this VC to hold the view that we want to show inside of a modal.
  fileprivate var modalVC: ContainerViewController!;
  
  // MARK: Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView();
  };
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder);
    setupView();
  };
  
  private func setupView(){
    // init RN-related properties
    self.nativeID = nil;
    
    // init ui-related values
    self.backgroundColor = .blue;
    
    let parentSize  = self.frame.size;
    let parentPoint = self.frame.origin;
    
    print("setupView - frame.size  : \(parentSize )");
    print("setupView - frame.origin: \(parentPoint)");
    
    // setup testView
    self.testView = {
      let width : CGFloat = 100;
      let height: CGFloat = 100;
      
      let view = UIView(frame: CGRect(
        origin: CGPoint(
          x: (parentPoint.x         ),
          y: (parentPoint.y - height)
        ),
        size: CGSize(
          width : width ,
          height: height
        )
      ));
      
      let label = UILabel();
      label.text = "Hello World";
      label.translatesAutoresizingMaskIntoConstraints = false;
      
      view.addSubview(label);
      view.backgroundColor = .yellow;
      
      // anchor to bottom left
      // note: make sure to addSubview first before activating constraints
      NSLayoutConstraint.activate([
        label.bottomAnchor  .constraint(equalTo: view.bottomAnchor  ),
        label.leadingAnchor .constraint(equalTo: view.leadingAnchor ),
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      ]);
      
      return view;
    }();
    
    // setup myButton
    self.myButton = {
      let btn = UIButton();
      
      btn.setTitle("Present Modal", for: .normal);
      btn.isUserInteractionEnabled = true;
      btn.backgroundColor = .orange;
      btn.sizeToFit();
      
      btn.addTarget(self,
        action: #selector(self.myButtonClicked),
        for   : .touchUpInside
      );
      
      return btn;
    }();
    
    // setup modalVC
    self.modalVC = ContainerViewController();
    
    self.addSubview(self.testView);
    self.addSubview(self.myButton);
  };
  
  // MARK: UIKit
  
  // UIKit lifecycle method
  // gets called everytime a view is added
  // even if that view is managed by RN
  override func didAddSubview(_ subview: UIView) {
    super.didAddSubview(subview);
    print("BlueBoxTestView: didAddSubview");
  };
  
  // UIKit lifecycle method
  // whenever the subviews's layout changes this method gets called.
  // this is probably a good place to do any side effects/changes to subviews.
  override func layoutSubviews() {
    print("BlueBoxTestView: layoutSubviews");
    
    // only react native child subviews will be changed
    let reactSubviews = self.reactSubviews() as [UIView];
    for (index, subview) in reactSubviews.enumerated() {
      if(index != 1){
        subview.backgroundColor = .red;
      };
      
      if let label = subview as? RCTTextView {
        // i can't seem to figure out how to change
        // the text value programatically
        let text = label.description;
        print("label text: \(text)");
      };
      
      // 1) what happens when you move a react subview to another subview? Does it still update via
      // setState etc.? Does it still change?
      // 1.1) Yes, it still updates, but since the layout was already computed via yoga before it
      // was moved, the other react children will act like it's still there (even when you move it).
      // (in other words, there's a gap where the view should have appeared originally).
      // 1.2) One sol. i tried was doing `removeReactSubview` after adding it to my own subview but
      // it didn't work bc the view might have been disposed/destroyed automatically when `removeReactSubview`
      // was called, so the view did not appear. I also tried not calling `super.insertReactSubview`
      // and add the subviews it to my custom subview but that didn't work. (furthermore, even if
      // we intercept the child view from `insertReactSubview` and modifity it from there, again, the
      // is already precomputed so we still have the same problem as 1.1.
      // 1.3) the easiest solution is to just apply `position: "absolute"` style from RN/js.
      // 1.3.1) if were trying to do everything from native side, i do not know how to programmatically
      // apply a position absolute style via native code, and computing the layout manually isn't really
      // a good idea anyways haha (i have to research a way to communicate with RN's layout system i.e yoga).
      // 1.3.1.1) It looks like a good place to start is RCTShadowView. You can define a custom shadow
      // view in the manager by overriding `shadowView`.
      // 1.3.1.2) Might be useful: https://github.com/facebook/react-native/issues/23806 - honestly,
      // I can't seem to find much docs. on RCTShadowView.
      // 1.3.2) Tho, the simplest solution is still just applying `position: "absolute"` in RN when we know
      // it's going to be "moved", in other words, manage it in JS (coordinate, i.e before "moving",
      // apply the absolute style first). But this requires communicating betw. RN and native code.
      // 1.3) I want to "reset" the subview, i.e remove any layout data calculated from yoga and use
      // autolayout. But when I try to add constraints, the subview just disapears (ps: i'm a abs. noob
      // w/ autolayout, so i'm propbably doing something wrong).
      //
      // 2) How do i know which subview is which? i.e how do i know which subview is the one i'm
      // intrested in? (i.e the one that i want to manipulate?)
      // 2.1) In this case, it's just the first subview (i.e the first child of this component in RN/js).
      // so just using index is sufficient. So in js/RN side, i should have some logic there in place
      // that guarantees that view I want to manipulate is at index 0 (by having a permanent view
      // "container/placeholder" as it's first child in the comp.), otherwise, other unrelated subviews
      // might get changed/mutated by accident.
      // 2.2) Another way is to use 'reactTag' property. Ask from js side what's the reactTag of the
      // view we want to manipulate, js then adds a `position: absolute` to "remove" it (so that it
      // no longer affects the layout of it's sibling views), and sends back the reactTag. We then use
      // the reactTag to identify the subview we want to manipulate.
      // 2.3) Similar to 2.2, another way is to use 'nativeID' property so we can just ask the bridge
      // to fetch that view. As a bonus, that view doesn't need to be a direct subview from this comp.,
      // i.e it can exist somewhere in the view hiearchy. Tho, this sounds like such a hassle...
      //
      // 3) Issue: https://github.com/facebook/react-native/issues/25234 - this one talks about mixing
      // autolayout and react native together, so it might be a useful ref.
      
      if (index == 0){
        let parentView = self.testView!;
        self.reactSubview = subview;
        
        // 1) i want to remove all layout info calc. by RN/yoga. in other words, i want to "reset" it.
        // But i'm not sure how to properly do it, so i'm just trying some stuff.
        // 2) But the layout is still being computed by RN/Yoga, so when it's orig parent view has some
        // layout chnage, the subview will still follow it. sigh. But since this particular subview
        // has `position: 'absolute'` style, it doesn't matter. TLDR: i want auto width and hieght.
        // 3) "Intrinsic Content Size" might be a good start to tackle this.
        subview.removeFromSuperview();
        //subview.removeAllConstraints();
        //subview.sizeToFit();
        
        // the only way  to "reset" is to explicitly set a new cgrect for the subview. But how do i
        // know what size and width it should be? How do i recompute it's original cgrect? For ex. somw
        // uilabel w/ some text/font style, what should it's frame be? When i created it, it was automatically
        // computed. So how do i recalculate the frame? idk. so for now, we'll just reset the origin,
        // and use the original size and width provided. again, since this subview is
        // `postion: 'absolute'` style in RN, it doesn't matter in this case.
        subview.frame = CGRect(
          origin: CGPoint(x: 0, y: 0),
          size  : subview.frame.size
        );
        
        // just setting this doesn't cause the subiew to dissapear
        //subview.translatesAutoresizingMaskIntoConstraints = false;
        
        parentView.addSubview(subview);
        
        // but when i try to activate a constraint, it dissapears lmao (evem when constraints are
        // just constants, it still dissapears. idk why haha). I think i'm missing something...
        //NSLayoutConstraint.activate([
        //  subview.widthAnchor.constraint(equalToConstant: 100),
        //  subview.bottomAnchor  .constraint(equalTo: parentView.bottomAnchor  ),
        //  subview.leadingAnchor .constraint(equalTo: parentView.leadingAnchor ),
        //  subview.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
        //]);
        
      } else if (index == 2) {
        // 1) this is an exp. to test out moving a subview to a vc and presenting it as a modal
        // 2) We need to call `removeFromSuperview` so that the subview no longer appears in the
        // blue box. Prev. i dind't call it, so the subview was still visible until I presented it.
        // 3) does the subview still update when we moved it to the vc?
        // 3.1) The view did appear, but when it was updated, it just dissapeared, in other words the
        // subview that we moved to the vc showed up but vanished the moment we updated it. (note that
        // sometimes the subview updates before dissapearing, ex: update -> updated -> dissapears).
        // 3.1.1) Apparently, once a UIViewController instance has a view, that is its view forever.
        // i was directly changing the view property, that's why it kept dissapearing. So i made a vc
        // that holds the react subview, so i dont directly change the vc's view. So it finally works
        // but i'm not sure that this is the correct way to do it...
        subview.removeFromSuperview();
        self.modalVC.reactView = subview;
      };
    };
  };
  
  // MARK: React Native
  
  // Used by the UIIManager to set the view frame.
  // gets called everytime the layout changes
  override func reactSetFrame(_ frame: CGRect) {
    let point = frame.origin;
    
    // you can change the cgrect values here but the flex layout
    // alignments computed by yoga will be off/mismatched so maybe this really
    // isn't a good idea haha (better to use styles or autolayout but not both?)
    let newFrame = CGRect(
      origin: CGPoint(x: point.x - 100, y: point.y - 100),
      size  : CGSize(width: 200, height: 200)
    );
    
    print("\n\nBlueBoxTestView: reactSetFrame, nativeID: \(self.nativeID ?? "N/A")");
    
    // it seems that only the frame param contains both the size and origin.
    // but reactContentFrame doesn't have a origin (it's set to 0, 0).
    print("BlueBoxTestView reactSetFrame frame size  : \(frame.size  )");
    print("BlueBoxTestView reactSetFrame frame origin: \(frame.origin)");
    
    // note: only the size is available. origin is (0, 0) so far.
    // commented w/ "Useful properties for computing layout."
    // so i guess it's used for convenience? but we already have self.frame tho...
    let reactCGRect = self.reactContentFrame;
    print("BlueBoxTestView reactContentFrame size  : \(reactCGRect.size  )");
    print("BlueBoxTestView reactContentFrame origin: \(reactCGRect.origin)");
    
    // note that the reactContentFrame and frame properties will contain the
    // prev. value when you read them before calling super.reactSetFrame
    super.reactSetFrame(newFrame);
    
    // basically contains whatever we pass to super reactSetFrame i'm not sure
    // why we should use reactContentFrame over the built in frame property.
    print("BlueBoxTestView frame size  : \(self.frame.size  )");
    print("BlueBoxTestView frame origin: \(self.frame.origin)");
    
    
    // there are two ways to count the number of subviews. Though, so far they always
    // have same value. reactSubviews is provided using a getter function, making
    // it read only. Are they the same views though? Or does reactSubviews contain extra properties?
    // It seems that reactSubviews will contain only subviews created from RN child views, whilst
    // subviews will contain both subviews added via insertSubview and RN child subviews.
    // note that nested views are not counted, only the direct subviews are counted (in other words
    // the subviews of a subview are not counted).
    print("BlueBoxTestView subview count      : \(self.subviews.count)");
    print("BlueBoxTestView react subview count: \(self.reactSubviews()?.count ?? 0)");
    
    for view: UIView in self.reactSubviews() {
      // it looks like every react managed view has a corresponding reactTag
      // it's just a number that gets incremented. The reactTag doesn't persist
      // after a view is remounted. But it does persist when a subview is only re-rendered
      // which makes sense bc it's the same view just updated.
      if let reactTag = view.reactTag {
        print("BlueBoxTestView: react subview reactTag: \(reactTag)");
      };
      
      // Desc: the native id of the view, used to locate view from native codes
      // it looks like neither BlueBoxTestView or it's subviews have a "nativeID" by default.
      // It isn't defned as a constant tho, so maybe the value isn't init./managed by RN?
      // according to the docs: "An ID which is used to associate this InputAccessoryView to specified TextInput(s)."
      // so it looks like it's a prop that we have to explicity set ourselves w/ some unique value.
      if let nativeID = view.nativeID {
        print("BlueBoxTestView: react subview nativeID: \(nativeID)");
      };
    };
    
    
    
    let parentSize = self.frame.size;
    let buttonSize = self.myButton.frame.size;
  
    // 1) why did I apply the cgrect size here instead of doing it in `setupView`?
    // 1.1) well, the frame doesn't have the `frame.size` yet. (Maybe bc in this particular case i
    // modified the frame from the native side?)
    // 1.2) Printing the `frame.size` and `frame.point` in `setupView` showed that they both have
    // `(0, 0)` as their intital value. Bc of this, I think that frame is only set when `reactSetFrame`
    // is called. Which makes sense, i just wanted to make sure haha. So when we want to modify the frame
    // of our UIView, it should be done here.
    //
    // 2) I wonder if there's another lifecycle func that gets called after `reactSetFrame` is set?
    // maybe a custom/private func that gets called when reactSetFrame is called, ex: didSetFrame...
    //
    // 3) note: the button needs to be inside of the bounds of the parent frame, otherwise it will be
    // visible but not interactable. This button will appear at the bottom of the blue box. However,
    // prev. the button was shown outside of the box. There has to be a away to either increase the
    // "interactable" bounds of the superview or allow the button to be interactable even if it's
    // outside the bounds of it's superview.
    self.myButton.frame = CGRect(
      origin: CGPoint(x: 0, y: (parentSize.height - buttonSize.height)),
      size  : buttonSize
    );
  };
  
  // RN lifecycle method
  // doesn't get called when a child is re-rendered
  // get's called when a child view is added/removed
  override func didUpdateReactSubviews() {
    super.didUpdateReactSubviews();
    print("BlueBoxTestView: didUpdateReactSubviews");
  };
  
  // 1) this isn't a lifecycle method but this is called everytime a react subview is added. probably
  // useful when you want to change the subview before adding?
  // 2) I tried not calling super, but it resulted in an error (even if it was only 1 subview). It looks
  // like all subviews need to be added (so super needs to be called everytime. for all subviews, i.e
  // you can't singe one out and choose not add it.)
  override func insertReactSubview(_ subview: UIView!, at atIndex: Int) {
    super.insertReactSubview(subview, at: atIndex);
    
    if atIndex == 1 {
      // manipulating the subview seems to persist, but is it a good idea to do that here? idk
      // If it I do it in layoutSubviews, i would have to loop through all the subviews one by one
      // and find the subview i want to change. But doing it here, i can "intercept" it, but i can only
      // do changes when that particular subview is being added. If i want to do changes later, i would
      // have store a ref. to that view. (But what if it was removed, and i try to use it. This requires
      // more maintanence, and could get messy really quick so idk)
      subview.backgroundColor = .green;
    };
    
    //if atIndex == 2 {
    //  subview.removeFromSuperview();
    //  self.modalVC.reactView = subview;
    //};
  };
  
  // this isn't a lifecycle method but this
  // is called everytime a react subview is removed.
  // probably useful when you want to change the view before removing?
  // maybe for cleanup? idk
  override func removeReactSubview(_ subview: UIView!) {
    super.removeReactSubview(subview);
    print("BlueBoxTestView: removeReactSubview");
  };
  
  // desc: called each time props have been set. The default implementation does nothing.
  override func didSetProps(_ changedProps: [String]!) {
    super.didSetProps(changedProps);
    
    let didSetNativeID = changedProps.contains("nativeID");
    
    if didSetNativeID {
      print("BlueBoxTestView, didSetProps nativeID: \(self.nativeID ?? "N/A")");
    };
  };
  
  // MARK: Handlers
  
  @objc func myButtonClicked(){
    print("BlueBoxTestView: myButtonClicked ");
    
    guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else {
      print("BlueBoxTestView - myButtonClicked: can't find rootViewController");
      return;
    };
    
    rootVC.present(self.modalVC, animated: true, completion: {});
    
  };
};


// hold a RN view as it's subview
fileprivate class ContainerViewController: UIViewController {
  
  private var _reactView: UIView?;
  var reactView: UIView? {
    set {
      guard let nextView = newValue else { return };
      //let prevView = self._reactView;
      
      self.view.insertSubview(nextView, at: 0);
      self._reactView = nextView;
    }
    get {
      return self._reactView;
    }
  };
  
  override func viewDidLoad() {
    super.viewDidLoad();
    
    // setup vc's view
    self.view = {
      let view = UIView();
      view.backgroundColor = .white;
      view.autoresizingMask = [
        .flexibleHeight,
        .flexibleWidth
      ];
      
      return view;
    }();
  };
};
