//
//  RCTListOrderViewProxy.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 7/4/20.
//

import Foundation
import UIKit
import SwiftUI

class RCTListOrderViewProxy: UIView {
  weak var bridge: RCTBridge?;
  
  private var hostVC     : UIHostingController<SwiftUIListOrder>!;
  private var listOrderVM: ListOrderViewModel!;
  
  @objc var listData: NSArray? {
    didSet {
      guard
        let listData = self.listData,
        listData.count > 0 else { return };
      
      self.updateListOrderVM(listData);
    }
  };
  
  init(bridge: RCTBridge) {
    super.init(frame: CGRect());
    
    self.listOrderVM = ListOrderViewModel();
    
    self.bridge = bridge;
    self.hostVC = UIHostingController(
      rootView: SwiftUIListOrder(
        isEditable : true,
        descLabel  : "Answer: ",
        listOrderVM: self.listOrderVM
      )
    );
    
    self.addSubview(self.hostVC.view);
  };
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented");
  };
  
  override func reactSetFrame(_ frame: CGRect) {
    super.reactSetFrame(frame);
    
    self.hostVC.view.frame = frame;
  };
  
  private func updateListOrderVM(_ listData: NSArray){
    var items: [ListOrderItem] = [];
    
    for listItem in listData {
      guard
        let dict          = listItem as? NSDictionary,
        let listOrderItem = ListOrderItem.init(dictionary: dict)
      else {
        #if DEBUG
        print("updateListOrderVM, skipping listItem...");
        dump(listItem);
        #endif
        continue;
      };
      
      items.append(listOrderItem);
    };
    
    self.listOrderVM.listItems = items;
    self.listOrderVM.objectWillChange.send();
  };
};
