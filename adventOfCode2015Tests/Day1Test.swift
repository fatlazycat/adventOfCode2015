//
//  adventOfCode2015Tests.swift
//  adventOfCode2015Tests
//
//  Created by Graham Berks on 26/12/2020.
//

import XCTest

class Day1Test: XCTestCase {

    func testExample() throws {
      let up = day1.map(String.init).filter{ $0 == "(" }.count
      let down = day1.map(String.init).filter{ $0 == ")" }.count
      XCTAssert(up - down == 280)
    }
}

extension String {
    var lines: [String] {
        return self.components(separatedBy: "\n")
    }
}
