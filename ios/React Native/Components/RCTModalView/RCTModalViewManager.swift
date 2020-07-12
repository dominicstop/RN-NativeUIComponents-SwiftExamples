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
  static var sharedInstance: RCTModalViewManager!;
  
  var presentedModals: [NSString] = [];
 
  override static func requiresMainQueueSetup() -> Bool {
    return true;
  };
 
  override func view() -> UIView! {
    let view = RCTModalView(bridge: self.bridge);
    view.delegate = self;
    
    return view;
  };
  
  override init() {
    super.init();
    RCTModalViewManager.sharedInstance = self;
  };
  
  @objc func requestModalPresentation(_ node: NSNumber, requestID: NSNumber, visibility: Bool){
    DispatchQueue.main.async {
      guard
        let component = self.bridge.uiManager.view(forReactTag: node),
        let modalView = component as? RCTModalView
      else {
        #if DEBUG
        print("RCTModalViewManager, requestModalOpen failed");
        #endif
        return;
      };
      
      #if DEBUG
      print(
          "RCTModalViewManager, requestModalOpen Received - "
        + "prevVisibility: \(modalView.isPresented) and nextVisibility: \(visibility) - "
        + "For node: \(node) and requestID: \(requestID)"
      );
      #endif
      
      modalView.requestModalPresentation(requestID, visibility);
    };
  };
};


extension RCTModalViewManager: RCTModalViewDelegate {
  func presentModalView(modalView: RCTModalView, viewController: RCTModalViewController) {
    self.presentedModals.append(
      modalView.modalID
    );
  };
  
  func dismissModalView(modalView: RCTModalView, viewController: RCTModalViewController) {
    if let index = self.presentedModals.firstIndex(of: modalView.modalID){
      self.presentedModals.remove(at: index);
    };
  };
};
