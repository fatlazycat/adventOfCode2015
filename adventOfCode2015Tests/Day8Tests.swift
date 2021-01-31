import XCTest
import SwiftHamcrest
import Parsing
import Foundation

class Day8Test: XCTestCase {
 
  func testPart1() throws {
    let contents = try String(contentsOfFile: Bundle(for: type(of: self)).path(forResource: "Day8Resources", ofType: "txt")!)
    print(contents)
  }
}
