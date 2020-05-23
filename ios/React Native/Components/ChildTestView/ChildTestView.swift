
import Foundation


class ChildTestView: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame);
    setupView();
  };
  
  override func layoutSubviews() {
    super.layoutSubviews();
  };
  
  override func insertReactSubview(_ subview: UIView!, at atIndex: Int) {
    super.insertReactSubview(subview, at: atIndex);
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
    let count = self.subviews.count;
    
    let text = UILabel();
    text.text = "Child Count: \(count)";
    text.translatesAutoresizingMaskIntoConstraints = false;
    
    self.addSubview(text);
  };
};

