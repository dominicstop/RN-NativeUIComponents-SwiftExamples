//
//  RCTMenuItem.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 7/14/20.
//

import Foundation;

public enum ImageType: String, CaseIterable, Encodable {
  case NONE   = "NONE";
  case URL    = "URL";
  case SYSTEM = "SYSTEM";
  
  static func withLabel(_ label: String) -> ImageType? {
    return self.allCases.first{ $0.rawValue == label };
  };
};


struct RCTMenuItem: Hashable, Encodable {
  
  var key           : String;
  var title         : String;
  var imageType     : ImageType;
  var imageValue    : String?;
  var menuState     : String?;
  var menuAttributes: [String];
  
  
  var image: UIImage? {
    switch self.imageType {
      case .NONE: return nil;
      case .URL : return nil; // to be implemented
      
      case .SYSTEM:
        guard let imageValue = self.imageValue else { return nil };
        return UIImage(systemName: imageValue);
    };
  };
  
  // Note: using computed property bc UIMenuElement.Attributes,
  // UIElement.State does not conform to Hashable/Encodable so
  // we cant use them as properties
  
  var uiMenuElementAttributes: UIMenuElement.Attributes {
    UIMenuElement.Attributes.init(
      self.menuAttributes.compactMap {
        UIMenuElement.Attributes.fromString($0);
      }
    );
  };
  
  var uiMenuElementState: UIMenuElement.State {
    guard
      let menuState        = self.menuState,
      let menuElementState = UIMenuElement.State.fromString(menuState)
    else { return .off };
    
    return menuElementState;
  };
  
  var identifier: UIAction.Identifier {
    UIAction.Identifier(self.key);
  };
  
  func makeUIAction(handler: @escaping UIActionHandler) -> UIAction{
    return UIAction(
      title     : self.title,
      image     : self.image,
      identifier: self.identifier,
      attributes: self.uiMenuElementAttributes,
      state     : self.uiMenuElementState,
      handler   : handler
    );
  };
};


extension RCTMenuItem {
  init?(dictionary: NSDictionary){
    guard
      let key            = dictionary["key"           ] as? String,
      let title          = dictionary["title"         ] as? String,
      let menuAttributes = dictionary["menuAttributes"] as? [String]

    else {
      #if DEBUG
      print("RCTMenuItem, init failed... dumping dictionary:");
      dump(dictionary);
      #endif
      return nil;
    };
    
    self.key            = key;
    self.title          = title;
    self.menuAttributes = menuAttributes;

    self.imageType = {
      let text = dictionary["imageType"] as? String ?? "";
      return ImageType.withLabel(text) ?? .NONE;
    }();
    
    self.menuState  = dictionary["menuState" ] as? String;
    self.imageValue = dictionary["imageValue"] as? String;
    
    print(self);
  };
};
