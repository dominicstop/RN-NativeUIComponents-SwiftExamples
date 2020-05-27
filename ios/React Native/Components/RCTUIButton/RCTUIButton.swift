

import Foundation

@objc (RCTUIButton)
class RCTUIButton: UIButton {
  
  // internal values
  private var _dummyBool: Bool?;
  
  // Exposed RN Props
  
  // expose a swift var as a computed property so you can
  // listen when the prop is being updated and you can internally
  // represent it with another var
  @objc var dummyBool: Bool {
    set(value) {
      print("dummyBool prop set: \(value)");
      self._dummyBool = value;
    }
    get {
      print("dummyBool prop read: \(String(describing: self._dummyBool))");
      return self._dummyBool ?? false;
    }
  };
  
  // directly expose a swift var as prop
  // the downside is you wont be able to listen when
  // the prop is being set
  @objc var dummyBool2: Bool = false;
  
  // for some weird reason, NSString props are always nil
  // even when you pass in a valid string prop value
  // this is a bug: https://github.com/facebook/react-native/issues/4829
  @objc var labelValue: NSString = "default value" {
    didSet(value){
      print("labelValue prop set: \(String(describing: value))");
      self.setTitle(String(describing: value), for: .normal);
    }
  };
  
  // this works, but labelValue does not. Only props that receive
  // string values have this bug.
  @objc var count: NSNumber = 0 {
    didSet {
      print("count prop set: \(String(describing: count))");
      self.setTitle(String(describing: count), for: .normal);
    }
  };
  
  // the workaround is to use a dictionary to receive the
  // String prop values
  @objc var config: NSDictionary = [:] {
    didSet {
      //setNeedsLayout();
      
      if let labelValue = config["labelValue"] as? String {
        print("config labelValue prop set: \(labelValue)");
        self.setTitle(labelValue, for: .normal);
      };
    }
  };
  
  // another workaround is to create an explicit setter function that's called from objc.
  // objc will call -[RCTUIButton setLabelValue2:] from the manager export macro.
  // tbh, this is my preffered way of doing it.
  @objc func setLabelValue2(_ labelValue2: NSString) {
    print("labelValue2 prop set: \(labelValue2)");
    self.setTitle(labelValue2 as String, for: .normal);
  };
  
  // prop that is used to call js func from native
  @objc var onClick: RCTBubblingEventBlock?;
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView();
  };

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder);
    setupView();
  };
  
  private func setupView(){
    self.setTitle("No title yet", for: .normal);
    self.isUserInteractionEnabled = true;
    
    self.addTarget(self,
      action: #selector(self.buttonClicked),
      for   : .touchUpInside
    );
  };
  
  @objc func buttonClicked() {
    if let onClick = self.onClick {
      onClick([
        "Test Param" : "Test Value"
      ]);
    };
  };
};
