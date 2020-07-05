//
//  RCTListOrderModel.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 7/4/20.
//

import Foundation

struct ListOrderItem: Hashable {
  var id         : String;
  var title      : String?;
  var description: String?;
}

extension ListOrderItem {
  init?(dictionary: NSDictionary){
    guard
      let id          = dictionary["id"         ] as? String,
      let title       = dictionary["title"      ] as? String,
      let description = dictionary["description"] as? String
    else {
      #if DEBUG
      print("ListOrderItem, init failed... dumping dictionary:");
      dump(dictionary);
      #endif
      return nil;
    };
    
    self.id          = id;
    self.title       = title;
    self.description = description;
  };
};

class ListOrderViewModel: ObservableObject {
  
  @Published var listItems: [ListOrderItem];
  
  init(listData: [ListOrderItem]? = nil){
    if let items = listData {
      self.listItems = items;
      
    } else {
      self.listItems = Array(0...10).map {
        ListOrderItem(
          id         : "id: \($0)",
          title      : "title #\($0)",
          description: "description #\($0)"
        );
      };
    };
  };
}
