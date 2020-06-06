
import Foundation


@objc (BlueBoxTestViewManager)
class BlueBoxTestViewManager: RCTViewManager {
 
  override static func requiresMainQueueSetup() -> Bool {
    return true;
  };
 
  override func view() -> UIView! {
    let instance = BlueBoxTestView();
    instance.bridge = self.bridge;
    
    return instance;
  };
  
  

};

