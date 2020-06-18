//
//  RCTModalView.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 6/9/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

class RCTModalView: UIView {
  
  weak var bridge  : RCTBridge?;
  weak var delegate: RCTModalViewDelegate?;
  
  var isPresented: Bool = false;
  
  private var modalVC     : RCTModalViewController!;
  private var touchHandler: RCTTouchHandler!;
  private var reactSubview: UIView?;
  
  @objc var onModalShow   : RCTDirectEventBlock?;
  @objc var onModalDismiss: RCTDirectEventBlock?;
  
  @objc var isModalInPresentation: Bool = false {
    willSet {
      if #available(iOS 13.0, *) {
        guard let vc = self.modalVC else { return };
        vc.isModalInPresentation = newValue
      };
    }
  };

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder);
    fatalError("Not implemented");
  };
  
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
  
  override func layoutSubviews() {
    let reactSubviews = self.reactSubviews() as [UIView];
    for (index, subview) in reactSubviews.enumerated() {
      if index == 0 {
        
        subview.removeFromSuperview();
        subview.frame = CGRect(
          origin: CGPoint(x: 0, y: 0),
          size  : subview.frame.size
        );
        
        self.touchHandler.attach(to: subview);
        
        self.reactSubview      = subview;
        self.modalVC.reactView = subview;
      };
    };
  };
  
  override func insertReactSubview(_ subview: UIView!, at atIndex: Int) {
    super.insertReactSubview(subview, at: atIndex);
    
    guard self.reactSubview == nil else {
      print("RCTModalView, insertReactSubview: Modal view can only have one subview");
      return;
    };
    
    
    self.reactSubview = subview;
  };
  
  override func removeReactSubview(_ subview: UIView!) {
    super.removeReactSubview(subview);
    print("RCTModalView, removeReactSubview");
    
    guard self.reactSubview == subview else {
      print("RCTModalView, removeReactSubview: Cannot remove view other than modal view");
      return;
    };
    
    guard (self.isPresented && self.superview != nil),
      let _ = UIApplication.shared.keyWindow?.rootViewController
    else { return };
    
    
  };
  
  override func didMoveToWindow() {
    super.didMoveToWindow();
    
    #if DEBUG
    print("\n\nRCTModalView, didMoveToWindow, isPresented: \(self.isPresented)");
    print("RCTModalView, didMoveToWindow, window: \(self.window != nil)");
    #endif
    
    guard self.delegate != nil else {
      print("RCTModalView, didMoveToWindow: guard check failed");
      return;
    };
    
    let hasWindow: Bool = (self.window != nil);
    if !hasWindow && self.isPresented {
      print("RCTModalView, didMoveToWindow: dismiss modal");
      self.modalVC.dismiss(animated: true){
        
      };
    };
  };
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview();
    
    #if DEBUG
    print("\n\nRCTModalView, didMoveToSuperview, isPresented: \(self.isPresented)");
    print("RCTModalView, didMoveToSuperview, window: \(self.window != nil)");
    #endif
    
    guard
      let rootVC        = UIApplication.shared.keyWindow?.rootViewController,
      let navController = rootVC as? UINavigationController,
      let _      = self.delegate
    else {
      print("RCTModalView, didMoveToSuperview: guard check failed");
      return;
    };
    
    let hasWindow: Bool = (self.window != nil);
    if hasWindow && !self.isPresented {
      self.isPresented = true;
      navController.modalPresentationStyle = .pageSheet;
      
      if let presentedVC = navController.presentedViewController  {
        presentedVC.present(self.modalVC, animated: true);
        
      } else {
        navController.present(self.modalVC, animated: true);
      };
    };
  };
  
  // MARK: Privste Functions
  
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
  
  private func dismissModalViewController(){
    guard !self.isPresented else { return };
    
    //self.delegate?.dismissModalView(modalView: self, viewController: self.modalVC);
  };
};
