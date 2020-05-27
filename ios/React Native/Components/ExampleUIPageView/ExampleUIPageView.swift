
import Foundation

// Wrap ExampleUIPageViewController inside this view and expode it to react-native
class ExampleUIPageView: UIView {
  
  weak var exampleUIPageVC: ExampleUIPageViewController?;
  
  override init(frame: CGRect) {
    super.init(frame: frame);
  };
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("NSCoder Not Implemented");
  };
  
  override func layoutSubviews() {
    super.layoutSubviews();

    if self.exampleUIPageVC == nil {
      self.embed();
      
    } else {
      self.exampleUIPageVC?.view.frame = self.bounds;
    };
  };
  
  private func embed() {
    guard let parentVC = parentViewController else {
      print("ParentVC not found.");
      return;
    };

    let vc = ExampleUIPageViewController();
    vc.view.frame = self.bounds;
    
    parentVC.addChild(vc);
    self.addSubview(vc.view);
    
    vc.didMove(toParent: parentVC);
    self.exampleUIPageVC = vc;
  };
};
