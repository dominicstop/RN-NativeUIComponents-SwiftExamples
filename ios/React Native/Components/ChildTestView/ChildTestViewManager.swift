
import Foundation


@objc (ChildTestViewManager)
class ChildTestViewManager: RCTViewManager {
 
  override static func requiresMainQueueSetup() -> Bool {
    return true
  };
 
  override func view() -> UIView! {
    return ChildTestView();
  };

};
