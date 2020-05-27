
import Foundation


class UIPageView: UIView {
  
  weak var uiPageViewController: UIPageViewControllerWrapper?;
  
  var childViewControllers = [UIViewController]();
  var currentIndex: Int = 0;
  
  var config: NSDictionary = [:] {
    didSet {
      setNeedsLayout();
    }
  };
  
  override init(frame: CGRect) {
    super.init(frame: frame);
  };
  
  override func layoutSubviews() {
    super.layoutSubviews();
    
    if self.uiPageViewController == nil {
      embed();
      
    } else {
      self.uiPageViewController?.view.frame = bounds;
    };
  };
  
  override func didUpdateReactSubviews(){
    super.didUpdateReactSubviews();
    
    guard self.reactSubviews().count != 0 else {
      return;
    };
    
    //self.addPages();
  };
  
  func addPages(){
    guard let vc = self.uiPageViewController else {
      return;
    };
    
    var tempChildVC = [UIViewController]();
    
    for view: UIView in self.reactSubviews() {
      let vc = UIViewController();
      vc.view = view;
      
      tempChildVC.append(vc);
    };
    
    self.childViewControllers = tempChildVC;
  };
  
  func renderChildVC(){
    var index = 0;
    
    for vc in self.childViewControllers {
      vc.removeFromParent();
    };
    
    self.childViewControllers.removeAll();
    
    for view in self.reactSubviews() {
      view.removeFromSuperview();
      
      let childVC = UIViewController();
      childVC.view = view;
      
      self.uiPageViewController?.setViewControllers([childVC], direction: .forward, animated: true, completion: { (b: Bool) in
        //
      })
      
      
      self.childViewControllers.append(childVC);
      index += 1;
    };
  };
  
  override func insertReactSubview(_ subview: UIView!, at atIndex: Int) {
    super.insertReactSubview(subview, at: atIndex);
  };
  
  override func removeReactSubview(_ subview: UIView!) {
    super.removeReactSubview(subview);
  };
  
  override func didAddSubview(_ subview: UIView) {
    super.didAddSubview(subview);
  };

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder);
    setupView();
  };
  
  // in here you can configure your view
  private func setupView(){
  };
  
  private func embed() {
    guard let parentVC = self.parentViewController else {
      return;
    };

    let vc = UIPageViewControllerWrapper();
    parentVC.addChild(vc);
    addSubview(vc.view);
    
    vc.view.frame = bounds;
    vc.didMove(toParent: parentVC);
    
    for view: UIView in self.reactSubviews() {
      view.removeFromSuperview();
      vc.addPage(view);
    };
    
    self.uiPageViewController = vc;
  };
};

