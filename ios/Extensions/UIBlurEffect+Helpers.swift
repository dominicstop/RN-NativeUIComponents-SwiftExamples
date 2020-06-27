//
//  UIBlurEffect+Helpers.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 6/26/20.
//

import Foundation

extension UIBlurEffect.Style: CaseIterable {
  public static var allCases: [UIBlurEffect.Style] {
    return [
      .systemUltraThinMaterial,
      .systemThinMaterial,
      .systemMaterial,
      .systemThickMaterial,
      .systemChromeMaterial,
      .systemMaterialLight,
      .systemThinMaterialLight,
      .systemUltraThinMaterialLight,
      .systemThickMaterialLight,
      .systemChromeMaterialLight,
      .systemChromeMaterialDark,
      .systemMaterialDark,
      .systemThickMaterialDark,
      .systemThinMaterialDark,
      .systemUltraThinMaterialDark,
      .regular,
      .prominent,
      .light,
      .extraLight,
      .dark,
    ];
  };
  
  func stringDescription() -> String {
    switch self {
      // Adaptable Styles
      case .systemUltraThinMaterial: return "systemUltraThinMaterial";
      case .systemThinMaterial     : return "systemThinMaterial";
      case .systemMaterial         : return "systemMaterial";
      case .systemThickMaterial    : return "systemThickMaterial";
      case .systemChromeMaterial   : return "systemChromeMaterial";
      
      // Light Styles
      case .systemMaterialLight         : return "systemMaterialLight";
      case .systemThinMaterialLight     : return "systemThinMaterialLight";
      case .systemUltraThinMaterialLight: return "systemUltraThinMaterialLight";
      case .systemThickMaterialLight    : return "systemThickMaterialLight";
      case .systemChromeMaterialLight   : return "systemChromeMaterialLight";
      
      // Dark Styles
      case .systemChromeMaterialDark   : return "systemChromeMaterialDark";
      case .systemMaterialDark         : return "systemMaterialDark";
      case .systemThickMaterialDark    : return "systemThickMaterialDark";
      case .systemThinMaterialDark     : return "systemThinMaterialDark";
      case .systemUltraThinMaterialDark: return "systemUltraThinMaterialDark";
      
      // Additional Styles
      case .regular   : return "regular";
      case .prominent : return "prominent";
      case .light     : return "light";
      case .extraLight: return "extraLight";
      case .dark      : return "dark";
      
      @unknown default: return "";
    };
  };
  
  static func fromString(_ string: String) -> UIBlurEffect.Style? {
    return self.allCases.first{ $0.stringDescription() == string };
  };
};
