//
//  RCTModalViewDelegate.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 6/17/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

protocol RCTModalViewDelegate: AnyObject {
  
  func presentModalView(modalView: RCTModalView, viewController: RCTModalViewController);
  
  func dismissModalView(modalView: RCTModalView, viewController: RCTModalViewController);
  
};
