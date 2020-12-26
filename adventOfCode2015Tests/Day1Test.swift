//
//  adventOfCode2015Tests.swift
//  adventOfCode2015Tests
//
//  Created by Graham Berks on 26/12/2020.
//

import XCTest
import SwiftHamcrest

class Day1Test: XCTestCase {

    func testPart1() throws {
      let up = day1.map(String.init).filter{ $0 == "(" }.count
      let down = day1.map(String.init).filter{ $0 == ")" }.count
      assertThat(up - down == 280)
    }
  
  func testPart2() throws {
    var current = 0
    var floor = 0
    
    while (floor != -1) {
      floor += day1[current] == "(" ? 1 : -1
      current += 1
    }
    
    assertThat(current == 1797)
  }
}

extension String {
    var lines: [String] {
        return self.components(separatedBy: "\n")
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
