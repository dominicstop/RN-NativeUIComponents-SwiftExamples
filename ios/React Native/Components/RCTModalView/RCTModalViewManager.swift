//
//  RCTModalViewManager.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 6/9/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

@objc (RCTModalViewManager)
class RCTModalViewManager: RCTViewManager {
 
  override static func requiresMainQueueSetup() -> Bool {
    return true;
  };
 
  override func view() -> UIView! {
    let view = RCTModalView(bridge: self.bridge);
    view.delegate = self;
    
    return view;
  };
  
  @objc func requestModalPresentation(_ node: NSNumber, requestID: NSNumber, visibility: Bool){
    DispatchQueue.main.async {
      guard
        let component = self.bridge.uiManager.view(forReactTag: node),
        let modalView = component as? RCTModalView
      else {
        print("RCTModalViewManager, requestModalOpen failed");
        return;
      };
      
      modalView.requestModalPresentation(requestID, visibility);
    };
  };
};


// WIP: not finished yet
extension RCTModalViewManager: RCTModalViewDelegate {
  func presentModalView(modalView: RCTModalView, viewController: RCTModalViewController) {
    
  };
  
  func dismissModalView(modalView: RCTModalView, viewController: RCTModalViewController) {
    
  };
};
