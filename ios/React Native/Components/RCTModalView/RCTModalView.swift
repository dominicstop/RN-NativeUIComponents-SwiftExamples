//
//  RCTModalView.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 6/9/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

typealias completionResult = ((Bool) -> ())?;

class RCTModalView: UIView {
  
  // ----------------
  // MARK: Properties
  // ----------------
  
  weak var bridge  : RCTBridge?;
  weak var delegate: RCTModalViewDelegate?;
  
  var isPresented: Bool = false;
  
  private var modalVC     : RCTModalViewController!;
  private var touchHandler: RCTTouchHandler!;
  private var reactSubview: UIView?;
  
  // -----------------------------
  // MARK: Properties: React Props
  // -----------------------------
  
  @objc var onModalShow    : RCTDirectEventBlock?;
  @objc var onModalDismiss : RCTDirectEventBlock?;
  @objc var onRequestResult: RCTDirectEventBlock?;
  
  // control modal present/dismiss by mounting/unmounting the react subview
  // * true : the modal is presented/dismissed when the view is mounted/unmounted
  // * false: the modal is presented/dismissed by calling the functions from js
  @objc var presentViaMount: Bool = false;
  
  @objc var isModalInPresentation: Bool = false {
    willSet {
      if #available(iOS 13.0, *) {
        guard let vc = self.modalVC else { return };
        vc.isModalInPresentation = newValue
      };
    }
  };
  
  // -------------------------------
  // MARK: Swift/UIKit Related Logic
  // -------------------------------
  
  init(bridge: RCTBridge) {
    super.init(frame: CGRect());
    
    self.bridge = bridge;
    self.touchHandler = RCTTouchHandler(bridge: self.bridge);
    
    self.modalVC = {
      let vc = RCTModalViewController();
      vc.boundsDidChangeBlock = { [weak self] (newBounds: CGRect) in
        self?.notifyForBoundsChange(newBounds);
      };
      
      return vc;
    }();
  };
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder);
    fatalError("Not implemented");
  };
  
  override func layoutSubviews() {
    super.layoutSubviews();
    print("RCTModalView, layoutSubviews");
    guard let reactSubview = self.reactSubview else { return };
    
    if !reactSubview.isDescendant(of: self.modalVC.view) {
      self.modalVC.reactView = reactSubview;
    };
  };
  
  override func didMoveToWindow() {
    super.didMoveToWindow();
    if self.presentViaMount {
      self.dismissModal();
    };
  };
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview();
    if self.presentViaMount {
      self.presentModal();
    };
  };
  
  // ----------------------
  // MARK: RN Related Logic
  // ----------------------
  
  override func insertReactSubview(_ subview: UIView!, at atIndex: Int) {
    super.insertReactSubview(subview, at: atIndex);
    print("RCTModalView, insertReactSubview");
    
    guard (self.reactSubview == nil),
      let bridge = self.bridge
    else {
      print("RCTModalView, insertReactSubview: Modal view can only have one subview");
      return;
    };
    
    subview.removeFromSuperview();
    subview.frame = CGRect(
      origin: CGPoint(x: 0, y: 0),
      size  : subview.frame.size
    );
    
    let newBounds = modalVC.view.bounds;
    bridge.uiManager.setSize(newBounds.size, for: subview);
    
    self.reactSubview = subview;
    self.touchHandler.attach(to: subview);
  };
  
  override func removeReactSubview(_ subview: UIView!) {
    super.removeReactSubview(subview);
    print("RCTModalView, removeReactSubview");
    
    guard self.reactSubview == subview else {
      print("RCTModalView, removeReactSubview: Cannot remove view other than modal view");
      return;
    };
    
    self.reactSubview = nil;
    self.modalVC.reactView = nil;
    self.touchHandler.detach(from: subview);
  };
  
  // --------------------------------------
  // MARK: Public Functions for ViewManager
  // --------------------------------------
  
  public func requestModalPresentation(
    _ requestID : NSNumber,
    _ visibility: Bool    ,
      completion: completionResult = nil
  ){
    var params: Dictionary<String, Any> = [
      "requestID" : requestID ,
      "visibility": visibility,
    ];
    
    if visibility {
      self.presentModal(){ success in
        params["success"] = success;
        completion?(success);
        
        self.onRequestResult?(params);
      };
      
    } else {
      self.dismissModal(){ success in
        params["success"] = success;
        completion?(success);
        
        self.onRequestResult?(params);
      };
    };
  };
  
  // -----------------------
  // MARK: Private Functions
  // -----------------------
  
  private func notifyForBoundsChange(_ newBounds: CGRect){
    guard (self.isPresented),
      let bridge       = self.bridge,
      let reactSubview = self.reactSubview
    else {
      print("RCTModalView, notifyForBoundsChange: guard check failed");
      return;
    };
    
    bridge.uiManager.setSize(newBounds.size, for: reactSubview);
  };
  
  private func presentModal(completion: completionResult = nil) {
    let hasWindow: Bool = (self.window != nil);
    
    guard (hasWindow && !self.isPresented),
      let rootVC = UIApplication.shared.keyWindow?.rootViewController
    else {
      print("RCTModalView, presentModal: guard check failed");
      completion?(false);
      return;
    };
    
    self.isPresented = true;
    
    var topmostVC = rootVC;
    while topmostVC.presentedViewController != nil {
      if let parent = topmostVC.presentedViewController {
        topmostVC = parent;
      };
    };
    
    topmostVC.present(self.modalVC, animated: true) {
      self.onModalShow?([:]);
      completion?(true);
    };
  };
  
  private func dismissModal(completion: completionResult = nil) {
    let hasWindow: Bool = (self.window != nil);
    
    guard hasWindow && self.isPresented else {
      print("RCTModalView, dismissModal failed: hasWindow: \(hasWindow) - isPresented \(self.isPresented)");
      completion?(false);
      return;
    };
    
    self.isPresented = false;
    self.modalVC.dismiss(animated: true){
      self.onModalDismiss?([:]);
      completion?(true);
      
      if let reactSubview = self.modalVC.reactView {
        self.removeReactSubview(reactSubview);
      };
    };
  };
};
