

import Foundation

class RedBoxTestView: UIView {
  
  @objc var status = false;
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView();
  };

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder);
    setupView();
  };
  
  @objc var onClick: RCTBubblingEventBlock?;
   
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let onClick = self.onClick else { return; };
    
    self.status = !self.status;
    self.backgroundColor = self.status ? .green : .red;
   
    let params: [String : Any] = ["value1":"react demo","value2":1];
    onClick(params)
  };
  
  private func setupView(){
    self.backgroundColor = self.status ? .green : .red;
    
    self.isUserInteractionEnabled = true
  };
};
