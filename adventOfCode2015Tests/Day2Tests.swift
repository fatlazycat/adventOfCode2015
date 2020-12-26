
import XCTest
import SwiftHamcrest
import Parsing

class Day2Test: XCTestCase {

    func testPart1() throws {
      let parser = Int.parser()
        .skip(StartsWith("x"))
        .take(Int.parser())
        .skip(StartsWith("x"))
        .take(Int.parser())
        .map{ (width: $0, height: $1, depth: $2) }
      
      let data = day2.lines.map{ parser.parse($0) }
      
      print(data)
      
//      assertThat(up - down == 280)
    }
}
