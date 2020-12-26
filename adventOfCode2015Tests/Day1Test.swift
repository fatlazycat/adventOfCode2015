//
//  adventOfCode2015Tests.swift
//  adventOfCode2015Tests
//
//  Created by Graham Berks on 26/12/2020.
//

import XCTest

class Day1Test: XCTestCase {

    func testExample() throws {
        let d1 = day1Part2.lines
        print(day1Part2)
    }
}

extension String {
    var lines: [String] {
        return self.components(separatedBy: "\n")
    }
}
