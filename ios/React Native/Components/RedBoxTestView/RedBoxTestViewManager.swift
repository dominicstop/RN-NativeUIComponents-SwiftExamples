
import Foundation


@objc (RedBoxTestViewManager)
class RedBoxTestViewManager: RCTViewManager {
 
  override static func requiresMainQueueSetup() -> Bool {
    return true
  };
 
  override func view() -> UIView! {
    return RedBoxTestView();
  };

};
