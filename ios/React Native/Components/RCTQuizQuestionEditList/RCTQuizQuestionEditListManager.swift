//
//  RCTQuizQuestionEditListManager.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 7/4/20.
//

import Foundation

@objc(RCTQuizQuestionEditListManager)
class RCTQuizQuestionEditListManager: RCTViewManager {
  
  override static func requiresMainQueueSetup() -> Bool {
     // true if you need this class initialized on the main thread
     // false if the class can be initialized on a background thread
     return true;
   };
  
   override func view() -> UIView! {
     return RCTQuizQuestionEditListProxy(bridge: self.bridge);
   };
};
