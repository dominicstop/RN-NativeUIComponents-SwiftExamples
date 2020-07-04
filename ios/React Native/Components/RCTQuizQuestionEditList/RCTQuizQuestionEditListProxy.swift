//
//  RCTQuizQuestionEditListProxy.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 7/4/20.
//

import Foundation
import SwiftUI

class RCTQuizQuestionEditListProxy: UIView {
  
  weak var bridge: RCTBridge?;
  
  private var hostVC: UIHostingController<RCTQuizQuestionEditList>!;
  
  init(bridge: RCTBridge) {
    super.init(frame: CGRect());
    
    self.bridge = bridge;
    self.hostVC = UIHostingController(rootView: RCTQuizQuestionEditList());
    
    self.addSubview(self.hostVC.view);
    
    self.backgroundColor = .red;
  };
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented");
  };
  
  override func reactSetFrame(_ frame: CGRect) {
    super.reactSetFrame(frame);
    
    self.hostVC.view.frame = frame;
  };
};
