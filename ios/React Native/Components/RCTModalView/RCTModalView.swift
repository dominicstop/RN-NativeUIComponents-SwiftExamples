//
//  RCTModalView.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 6/9/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

typealias completionResult = ((_ isSuccess: Bool, _ error: RCTModalViewError?) -> ())?;

class RCTModalView: UIView {
  
  // ----------------
  // MARK: Properties
  // ----------------
  
  weak var bridge  : RCTBridge?;
  weak var delegate: RCTModalViewDelegate?;
  
  var isPresented: Bool = false;
  
  private var modalVC     : RCTModalViewController!;
  private var modalNVC    : UINavigationController!;
  private var touchHandler: RCTTouchHandler!;
  private var reactSubview: UIView?;
  
  // ------------------------------------------------
  // MARK: Properties: React Props - Events/Callbacks
  // ------------------------------------------------
  
  // RN event callback for when a RCTModalViewManager "command"
  // has been completed via dispatchViewManagerCommand from js.
  // Used in js/rn-side for wrapping UIManager commands inside
  // promises so they can be resolved/rejected.
  @objc var onRequestResult: RCTDirectEventBlock?;
  
  // RN event callbacks for whenever a modal is presented/dismissed
  // via functions or from swipe to dismiss gestures
  @objc var onModalShow   : RCTDirectEventBlock?;
  @objc var onModalDismiss: RCTDirectEventBlock?;
  
  // RN event callbacks for: UIAdaptivePresentationControllerDelegate
  // Note: that these are only invoked in response to dismiss gestures
  @objc var onModalDidDismiss    : RCTDirectEventBlock?;
  @objc var onModalWillDismiss   : RCTDirectEventBlock?;
  @objc var onModalAttemptDismiss: RCTDirectEventBlock?;
  
  // ---------------------------------------------
  // MARK: Properties: React Props - "Value" Props
  // ---------------------------------------------
  
  @objc var isModalBGBlurred: Bool = true {
    didSet {
      guard oldValue != self.isModalBGBlurred else { return };
      self.modalVC.isBGBlurred = self.isModalBGBlurred;
    }
  };
  
  @objc var isModalBGTransparent: Bool = true {
    didSet {
      guard oldValue != self.isModalBGTransparent else { return };
      self.modalVC.isBGTransparent = self.isModalBGTransparent;
    }
  };
  
  @objc var modalBGBlurEffectStyle: NSString = "systemThinMaterial" {
    didSet {
      guard oldValue != self.modalBGBlurEffectStyle
      else { return };
      
      guard let blurStyle = UIBlurEffect.Style.fromString(self.modalBGBlurEffectStyle as String)
      else {
        RCTLogWarn("RCTModalView, modalBGBlurEffectStyle: Invalid value");
        return;
      };
      
      self.modalVC.blurEffectStyle = blurStyle;
    }
  };
  
  private var _modalPresentationStyle: UIModalPresentationStyle = .automatic;
  @objc var modalPresentationStyle: NSString = "automatic" {
    didSet {
      guard oldValue != self.modalPresentationStyle
      else { return };
      
      guard let style = UIModalPresentationStyle.fromString(self.modalPresentationStyle as String)
      else {
        RCTLogWarn("RCTModalView, modalPresentationStyle: Invalid value");
        return;
      };
      
      switch style {
        case .automatic,
             .pageSheet,
             .formSheet,
             .overFullScreen:
          
          self._modalPresentationStyle = style;
          #if DEBUG
          print("RCTModalView, modalPresentationStyle didSet: \(style.stringDescription())");
          #endif

        default:
          RCTLogWarn("RCTModalView, modalPresentationStyle: Unsupported Presentation Style");
      };
    }
  };
  
  private var _modalTransitionStyle: UIModalTransitionStyle = .coverVertical;
  @objc var modalTransitionStyle: NSString = "coverVertical" {
    didSet {
      guard oldValue != self.modalTransitionStyle
      else { return };
      
      guard let style = UIModalTransitionStyle.fromString(self.modalTransitionStyle as String)
      else {
        RCTLogWarn("RCTModalView, modalTransitionStyle: Invalid value");
        return;
      };
      
      self._modalTransitionStyle = style;
      #if DEBUG
      print("RCTModalView, modalTransitionStyle didSet: \(style.stringDescription())");
      #endif
    }
  };
  
  @objc var modalID: NSString = "";
  
  // control modal present/dismiss by mounting/unmounting the react subview
  // * true : the modal is presented/dismissed when the view is mounted/unmounted
  // * false: the modal is presented/dismissed by calling the functions from js
  @objc var presentViaMount: Bool = false;
  
  // allow modal to be programatically closed even when not current focused
  // * true : the modal can be dismissed even when it's not the topmost presented modal
  // * false: the modal can only be dismissed if it's in focus, otherwise error
  @objc var allowModalForceDismiss: Bool = true;
  
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
      vc.isBGBlurred     = self.isModalBGBlurred;
      vc.isBGTransparent = self.isModalBGTransparent;
      
      if let blurStyle = UIBlurEffect.Style
        .fromString(self.modalBGBlurEffectStyle as String) {
        
        vc.blurEffectStyle = blurStyle;
      };
      
      vc.boundsDidChangeBlock = { [weak self] (newBounds: CGRect) in
        self?.notifyForBoundsChange(newBounds);
      };
      
      return vc;
    }();
    
    self.modalNVC = {
      let nvc = UINavigationController(rootViewController: self.modalVC);
      nvc.presentationController?.delegate = self;
      nvc.setNavigationBarHidden(true, animated: false);
      
      return nvc;
    }();
  };
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder);
    fatalError("Not implemented");
  };
  
  override func layoutSubviews() {
    super.layoutSubviews();
    guard let reactSubview = self.reactSubview else { return };
    
    #if DEBUG
    print("RCTModalView, layoutSubviews - for reactTag: \(self.reactTag ?? -1)");
    #endif
    
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
    
    guard (self.reactSubview == nil),
      let bridge = self.bridge
    else {
      RCTLogWarn("RCTModalView, insertReactSubview: Modal view can only have one subview");
      return;
    };
    
    #if DEBUG
    print("RCTModalView, insertReactSubview - for reactTag: \(self.reactTag ?? -1)");
    #endif
    
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
    
    guard self.reactSubview == subview else {
      RCTLogWarn("RCTModalView, removeReactSubview: Cannot remove view other than modal view");
      return;
    };
    
    #if DEBUG
    print("RCTModalView, removeReactSubview - for reactTag: \(self.reactTag ?? -1)");
    #endif
    
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
    
    let modalAction = visibility
      ? self.presentModal
      : self.dismissModal
    
    modalAction(){ (success, error) in
      params["success"] = success;
      if let errorCode = error {
        params["errorCode"   ] = errorCode.rawValue;
        params["errorMessage"] = RCTModalViewError.getErrorMessage(for: errorCode)
      };
      
      completion?(success, error);
      self.onRequestResult?(params);
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
    
    #if DEBUG
    print("RCTModalView, notifyForBoundsChange - for reactTag: \(self.reactTag ?? -1)");
    #endif
    
    bridge.uiManager.setSize(newBounds.size, for: reactSubview);
  };
  
  private func getTopMostPresentedVC() -> UIViewController? {
    guard let rootVC = UIWindow.key?.rootViewController else {
      print("RCTModalView, getTopMostVC Error: could not get root VC. ");
      return nil;
    };
    
    // climb the vc hierarchy to find the topmost presented vc
    var topmostVC = rootVC;
    while topmostVC.presentedViewController != nil {
      if let parent = topmostVC.presentedViewController {
        topmostVC = parent;
      };
    };
    
    return topmostVC;
  };
  
  private func getPresentedVCList() -> [UIViewController] {
    guard let rootVC = UIWindow.key?.rootViewController else {
      print("RCTModalView, getTopMostVC Error: could not get root VC. ");
      return [];
    };
    
    var vcList: [UIViewController] = [];
    vcList.append(rootVC);
    
    // climb the vc hierarchy to find the topmost presented vc
    while let presentedVC = vcList.last?.presentedViewController {
      vcList.append(presentedVC);
    };
    
    return vcList;
  };
  
  private func isModalInFocus() -> Bool {
    return self.getTopMostPresentedVC() === self.modalNVC;
  };
  
  private func presentModal(completion: completionResult = nil) {
    let hasWindow: Bool = (self.window != nil);
    
    guard (hasWindow && !self.isPresented),
      let topMostPresentedVC = self.getTopMostPresentedVC()
    else {
      print("RCTModalView, presentModal: guard check failed");
      completion?(false, .modalAlreadyPresented);
      return;
    };
    
    self.modalNVC.presentationController?.delegate = self;
    self.modalNVC.modalTransitionStyle   = self._modalTransitionStyle;
    self.modalNVC.modalPresentationStyle = self._modalPresentationStyle;
    
    #if DEBUG
    print("RCTModalView, presentModal: Start - for reactTag: \(self.reactTag ?? -1)");
    #endif
    
    self.isPresented = true;
    topMostPresentedVC.present(modalNVC, animated: true) {
      self.onModalShow?([:]);
      completion?(true, nil);
      
      #if DEBUG
      print("RCTModalView, presentModal: Finished");
      #endif
    };
  };
  
  private func dismissModal(completion: completionResult = nil) {
    let hasWindow: Bool = (self.window != nil);
    
    guard hasWindow && self.isPresented else {
      print("RCTModalView, dismissModal failed: hasWindow: \(hasWindow) - isPresented \(self.isPresented)");
      completion?(false, .modalAlreadyDismissed);
      return;
    };
    
    let isModalInFocus = self.isModalInFocus();
    
    guard isModalInFocus && self.allowModalForceDismiss else {
      print("RCTModalView, dismissModal failed: Modal not in focus");
      completion?(false, .modalDismissFailedNotInFocus);
      return;
    };
    
    let presentedVC: UIViewController = isModalInFocus
      ? self.modalVC
      : self.modalVC.presentingViewController!
    
    #if DEBUG
    print("RCTModalView, dismissModal: Start - for reactTag: \(self.reactTag ?? -1)");
    #endif
    
    self.isPresented = false;
    presentedVC.dismiss(animated: true){
      self.onModalDismiss?([:]);
      completion?(true, nil);
      
      #if DEBUG
      print("RCTModalView, dismissModal: Finished");
      #endif
      
      if let reactSubview = self.modalVC.reactView {
        #if DEBUG
        print("RCTModalView, dismissModal: Removing React Subview");
        #endif
        
        self.removeReactSubview(reactSubview);
      };
    };
  };
};

// ---------------------------------------------------------
// MARK: Extension: UIAdaptivePresentationControllerDelegate
// ---------------------------------------------------------

extension RCTModalView: UIAdaptivePresentationControllerDelegate {
    
  func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
    self.onModalWillDismiss?([:]);
    
    #if DEBUG
    print("RCTModalView, presentationControllerWillDismiss"
      + " - for reactTag: \(self.reactTag ?? -1)"
    );
    #endif
  };
  
  func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    self.onModalDismiss?([:]);
    self.onModalDidDismiss?([:]);
    
    if let reactSubview = self.modalVC.reactView {
      #if DEBUG
      print("RCTModalView, presentationControllerDidDismiss: Removing React Subview");
      #endif
      
      self.removeReactSubview(reactSubview);
    };
    
    #if DEBUG
    print("RCTModalView, presentationControllerDidDismiss"
      + " - for reactTag: \(self.reactTag ?? -1)"
    );
    #endif
  };
  
  func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
    self.onModalAttemptDismiss?([:]);
    
    #if DEBUG
    print("RCTModalView, presentationControllerDidAttemptToDismiss"
      + " - for reactTag: \(self.reactTag ?? -1)"
    );
    #endif
  };
};
