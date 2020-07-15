//
//  RCTMenuItem.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 7/14/20.
//

import Foundation;

public typealias UIActionHandlerWithKey = (String, UIAction) -> Void;

public enum ImageType: String, CaseIterable, Encodable {
  case NONE   = "NONE";
  case URL    = "URL";
  case SYSTEM = "SYSTEM";
  
  static func withLabel(_ label: String) -> ImageType? {
    return self.allCases.first{ $0.rawValue == label };
  };
};

// -----------------
// MARK: RCTMenuItem
// -----------------

struct RCTMenuItem: Hashable, Encodable {
  
  var key           : String;
  var title         : String;
  var imageType     : ImageType;
  var imageValue    : String?;
  var menuState     : String?;
  var menuAttributes: [String]?;
  
  var submenuItems: [RCTMenuItem]?;
  
};

// ------------------------
// MARK: RCTMenuItem - Init
// ------------------------

extension RCTMenuItem {
  init?(dictionary: NSDictionary){
    guard
      let key   = dictionary["key"  ] as? String,
      let title = dictionary["title"] as? String

    else {
      #if DEBUG
      print("RCTMenuItem, init failed... dumping dictionary:");
      dump(dictionary);
      #endif
      return nil;
    };
    
    self.key   = key;
    self.title = title;

    self.imageType = {
      let text = dictionary["imageType"] as? String ?? "";
      return ImageType.withLabel(text) ?? .NONE;
    }();
    
    self.menuState      = dictionary["menuState"     ] as? String;
    self.imageValue     = dictionary["imageValue"    ] as? String;
    self.menuAttributes = dictionary["menuAttributes"] as? [String];
    
    if let submenuItems = dictionary["submenuItems"] as? NSArray {
      self.submenuItems = submenuItems.compactMap {
        RCTMenuItem(dictionary: $0 as? NSDictionary)
      };
    };
  };
  
  init?(dictionary: NSDictionary?){
    guard let dictionary = dictionary else { return nil };
    self.init(dictionary: dictionary);
  };
};

// ---------------------------------------
// MARK: RCTMenuItem - Computed Properties
// ---------------------------------------

extension RCTMenuItem {
  
  // Note: using computed property bc UIMenuElement.Attributes,
  // UIElement.State does not conform to Hashable/Encodable so
  // we cant use them as properties
  
  var uiMenuElementAttributes: UIMenuElement.Attributes {
    UIMenuElement.Attributes.init(
      self.menuAttributes?.compactMap {
        UIMenuElement.Attributes.fromString($0);
      } ?? []
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
  
  var image: UIImage? {
    switch self.imageType {
      case .NONE: return nil;
      case .URL : return nil; // to be implemented
      
      case .SYSTEM:
        guard let imageValue = self.imageValue else { return nil };
        return UIImage(systemName: imageValue);
    };
  };
  
};

// -----------------------------
// MARK: RCTMenuItem - Functions
// -----------------------------

extension RCTMenuItem {
  
  func makeUIAction(handler: @escaping UIActionHandlerWithKey) -> UIAction {
    return UIAction(
      title     : self.title,
      image     : self.image,
      identifier: self.identifier,
      attributes: self.uiMenuElementAttributes,
      state     : self.uiMenuElementState,
      handler   : { handler(self.key, $0) }
    );
  };
  
  func makeSubmenu(handler: @escaping UIActionHandlerWithKey) -> UIMenu {
    return UIMenu(
      title: self.title,
      image: self.image,
      children:
        self.submenuItems?.compactMap { $0.makeUIAction(handler: handler) }
        ?? []
    );
  };
  
  func makeUIMenuElement(handler: @escaping UIActionHandlerWithKey) -> UIMenuElement {
    return self.submenuItems != nil
      ? self.makeSubmenu (handler: handler)
      : self.makeUIAction(handler: handler)
  };
};
