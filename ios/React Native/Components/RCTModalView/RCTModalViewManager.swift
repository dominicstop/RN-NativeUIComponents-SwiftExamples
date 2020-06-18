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
};

extension RCTModalViewManager: RCTModalViewDelegate {
  func presentModalView(modalView: RCTModalView, viewController: RCTModalViewController) {
    
  };
  
  func dismissModalView(modalView: RCTModalView, viewController: RCTModalViewController) {
    
  };
};
