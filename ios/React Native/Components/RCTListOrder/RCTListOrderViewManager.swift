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
  
  @objc func requestListData(_ node: NSNumber, requestID: NSNumber){
    DispatchQueue.main.async {
      guard
        let component = self.bridge.uiManager.view(forReactTag: node),
        let listProxy = component as? RCTListOrderViewProxy
      else {
        print("RCTListOrderViewManager, requestListData failed");
        return;
      };
      
      #if DEBUG
      print("RCTListOrderViewManager, requestListData Received - "
        + "For node: \(node) and requestID: \(requestID)"
      );
      #endif
      
      listProxy.requestListData(requestID);
    };
  };
};
