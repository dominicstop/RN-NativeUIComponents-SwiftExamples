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
  
  @objc var listData: NSArray? {
    didSet {
      //dump(self.listData)
      for item in self.listData! {
        let dict = item as! NSDictionary;
        print("listData item: \(item)");
        print("dict: \(dict)");
      };
    }
  };
  
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
  
  private func parseListData(_ listData: NSArray){
    let items: [QuizQuestionItem] = [];
    
    for listItem in listData {
      guard
        let dict   = listItem as? NSDictionary,
        let quizID = dict["quizID"]
      else {
        continue;
      };
    };
  };
};
