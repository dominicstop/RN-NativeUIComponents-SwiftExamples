//
//  Unwrap.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 7/4/20.
//

import SwiftUI

// This comp. mimics react's conditional rendering
// source: https://www.swiftbysundell.com/tips/optional-swiftui-views/
struct Unwrap<Value, Content: View>: View {
  private let value: Value?;
  private let contentProvider: (Value) -> Content;

  init(_ value: Value?,
     @ViewBuilder content: @escaping (Value) -> Content) {
    
    self.value           = value;
    self.contentProvider = content;
  };

  var body: some View {
    value.map(contentProvider)
  };
};
