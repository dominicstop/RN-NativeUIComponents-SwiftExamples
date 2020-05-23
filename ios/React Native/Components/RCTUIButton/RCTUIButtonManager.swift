

import Foundation

@objc (RCTUIButtonManager)
class RCTUIButtonManager: RCTViewManager {
 
  override static func requiresMainQueueSetup() -> Bool {
    // true if you need this class initialized on the main thread
    // false if the class can be initialized on a background thread
    return true;
  };
 
  override func view() -> UIView! {
    return RCTUIButton();
  };

};
