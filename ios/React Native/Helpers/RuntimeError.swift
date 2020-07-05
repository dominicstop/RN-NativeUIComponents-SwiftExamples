//
//  RuntimeError.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 7/4/20.
//

import Foundation

public struct RuntimeError: Error {
  let message: String

  init(_ message: String) {
    self.message = message
  };

  public var localizedDescription: String {
    return message
  };
};
