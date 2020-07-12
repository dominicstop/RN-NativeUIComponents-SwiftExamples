//
//  RCTModalViewModule.swift
//  RNSwiftReviewer
//
//  Created by Dominic Go on 7/11/20.
//

import Foundation


@objc(RCTModalViewModule)
class RCTModalViewModule: NSObject {
  
  @objc static func requiresMainQueueSetup() -> Bool {
    return false;
  };
  
  @objc func dismissModalByID(_ modalID: NSString, callback: @escaping RCTResponseSenderBlock) {
    DispatchQueue.main.async {
      guard let rootVC = UIWindow.key?.rootViewController else {
        #if DEBUG
        print("RCTModalViewModule, dismissModalByID Error: could not get root VC. ");
        #endif
        return;
      };
      
      // climb the vc hierarchy to find the modal
      var currentVC = rootVC;
      while let presentedVC = currentVC.presentedViewController {
        currentVC = presentedVC;

        if let navVC     = presentedVC as? UINavigationController,
           let rootVC    = navVC.viewControllers.first,
           let modalVC   = rootVC as? RCTModalViewController,
           modalVC.modalID == modalID {
          
          modalVC.dismiss(animated: true){
            callback([true]);
            
            let manager = RCTModalViewManager.sharedInstance;
            if let index = manager?.presentedModals.firstIndex(of: modalID){
              manager?.presentedModals.remove(at: index);
            };
            
            #if DEBUG
            print("RCTModalViewModule, dismissModalByID: dismissing \(modalVC.modalID ?? "N/A")");
            #endif
          };
          
          // early exit, stop loop
          return;
        };
        
        // modal not found
        callback([false]);
      };
    };
  };
};
