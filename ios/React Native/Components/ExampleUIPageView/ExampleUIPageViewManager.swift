
import Foundation

@objc (ExampleUIPageViewManager)
class ExampleUIPageViewManager: RCTViewManager {
 
  override static func requiresMainQueueSetup() -> Bool {
    return true;
  };
 
  override func view() -> UIView! {
    return ExampleUIPageView();
  };
};
