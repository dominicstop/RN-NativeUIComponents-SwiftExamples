//
//  RCTListOrderViewManager.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 7/4/20.
//

import Foundation

@objc(RCTListOrderViewManager)
class RCTListOrderViewManager: RCTViewManager {
  
  override static func requiresMainQueueSetup() -> Bool {
     return true;
   };
  
   override func view() -> UIView! {
     return RCTListOrderViewProxy(bridge: self.bridge);
   };
};
