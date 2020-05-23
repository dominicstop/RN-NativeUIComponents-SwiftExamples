//
//  UIPageViewManager.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 5/22/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation


@objc (UIPageViewManager)
class UIPageViewManager: RCTViewManager {
 
  override static func requiresMainQueueSetup() -> Bool {
    return true;
  };
 
  override func view() -> UIView! {
    return UIPageView();
  };

};
