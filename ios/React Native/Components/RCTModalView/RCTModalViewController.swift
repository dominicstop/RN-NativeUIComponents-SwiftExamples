//
//  RCTModalViewController.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 6/9/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

class RCTModalViewController: UIViewController {
  
  var lastViewFrame: CGRect?;
  var boundsDidChangeBlock: ((CGRect) -> Void)?;
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return RCTSharedApplication()?.statusBarStyle ?? .default;
  };
  
  override var prefersStatusBarHidden: Bool {
    return RCTSharedApplication()?.isStatusBarHidden ?? false;
  };
  
  var reactView: UIView? {
    didSet {
      guard let nextView = reactView else { return };
      
      if oldValue?.reactTag != nextView.reactTag {
        self.view.insertSubview(nextView, at: 0);
      };
    }
  };
  
  override func viewDidLoad() {
    super.viewDidLoad();
    
    #if DEBUG
    print("RCTModalViewController, viewDidLoad");
    #endif
    
    // setup vc's view
    self.view = {
      let view = UIView();
      view.backgroundColor = .white;
      view.autoresizingMask = [
        .flexibleHeight,
        .flexibleWidth
      ];
      return view;
    }();
    
    if let boundsDidChangeBlock = self.boundsDidChangeBlock {
      boundsDidChangeBlock(self.view.bounds);
    };
  };
  
  override func viewDidLayoutSubviews(){
    super.viewDidLayoutSubviews();
    
    guard let boundsDidChangeBlock = self.boundsDidChangeBlock else {
      print("RCTModalViewController, viewDidLayoutSubviews: guard check failed");
      return;
    };
    
    #if DEBUG
    print("RCTModalViewController, viewDidLayoutSubviews");
    #endif
    
    let didChangeViewFrame: Bool = !(
      lastViewFrame?.equalTo(self.view.frame) ?? false
    );
    
    if didChangeViewFrame {
      boundsDidChangeBlock(self.view.bounds);
      self.lastViewFrame = self.view.frame;
    };
  };
};
