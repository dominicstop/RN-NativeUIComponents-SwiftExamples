

import Foundation

class BlueBoxTestView: UIView {
  
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
  
  var testView: UIView!;
  var reactSubview: UIView?;
  
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
    
    self.testView = {
      let parentPoint = self.frame.origin;
      
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
    
    self.addSubview(self.testView);
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
      subview.backgroundColor = .red;
      
      if let label = subview as? RCTTextView {
        // i can't seem to figure out how to change
        // the text value programatically
        let text = label.description;
        print("label text: \(text)");
      };
      
      // what happens when you move a react subview to another subview?
      // 1) Does it still update via setState etc.? Yes, it still updates, but since the layout is
      // was already computed via yoga before it was moved, even when you move it, the other react
      // children will act like it's still there (in other words, there's a gap where the view should
      // have appeared originally).
      // 1.1) One soluton i tried was doing removeReactSubview after adding it to my own subview but
      // it didn't work bc the view might have been disposed automatically whenever removeReactSubview
      // is called. I also tried not calling super.insertReactSubview and and add it to my custom subview
      // but that didn't work (Even if intercept the child view from insertReactSubview, again, the
      // is already precomputed. Thus, not adding it will not change anything).
      // 1.2) the easiest solution is just apply "position: absolute" style from RN. Though, if were
      // trying to do everything from native side.
      // 1.2.1) i do not know how to programmatically apply a position
      // absolute style via native code, and computing the layout manually isn't really a good idea
      // (i have to research a way to communicate with RN layout system i.e yoga).
      // 1.2.2) Tho, the simplest solution is still applying "position: absoulte" in RN when we know
      // it's going to be "moved", in other words, manage it in JS (coordinate, i.e before "moving",
      // request the style change first).
      // 1.3) I want to "reset" the subview, i.e remove any layout data calculated from yoga and use
      // autolayout. But when I try to add constraints, the subview just disapears (ps: i'm a abs noob
      // w/ autolayout). 
  
      if(index == 0){
        let parentView = self.testView!;
        self.reactSubview = subview;
        
        // replace frame computed from yoga w/ custom frame
        subview.removeAllConstraints();
        subview.frame = CGRect(
          origin: CGPoint(x: 0, y: 0),
          size  : CGSize (width: 50, height: 50)
        );
        
        //subview.translatesAutoresizingMaskIntoConstraints = false;
        parentView.addSubview(subview);
        
        //NSLayoutConstraint.activate([
        //  subview.bottomAnchor  .constraint(equalTo: parentView.bottomAnchor  ),
        //  subview.leadingAnchor .constraint(equalTo: parentView.leadingAnchor ),
        //  subview.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
        //]);
        
        
        subview.setNeedsLayout();
        
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
      // It isn't defned as a constant tho, so maybe the value isn't init./managed by RN.
      // according to the docs: "An ID which is used to associate this InputAccessoryView to specified TextInput(s)."
      // so it looks like it's a prop that we have to explicity set ourselves w/ some unique value
      if let nativeID = view.nativeID {
        print("BlueBoxTestView: react subview nativeID: \(nativeID)");
      };
    };
  };
  
  // RN lifecycle method
  // doesn't get called when a child is re-rendered
  // get's called when a child view is added/removed
  override func didUpdateReactSubviews() {
    super.didUpdateReactSubviews();
    print("BlueBoxTestView: didUpdateReactSubviews");
  };
  
  // this isn't a lifecycle method but this
  // is called everytime a react subview is added.
  // probably useful when you want to change the subview before adding?
  override func insertReactSubview(_ subview: UIView!, at atIndex: Int) {
    super.insertReactSubview(subview, at: atIndex);
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
};
