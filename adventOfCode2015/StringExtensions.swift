//
//  StringExtensions.swift
//  adventOfCode2015
//
//  Created by Graham Berks on 26/12/2020.
//

import Foundation

extension String {
  var lines: [String] {
    return self.components(separatedBy: "\n")
  }
  
  func toCharArray() -> [Character] {
    return Array(self)
  }
}

extension StringProtocol {
  subscript(offset: Int) -> Character {
    self[index(startIndex, offsetBy: offset)]
  }
}
