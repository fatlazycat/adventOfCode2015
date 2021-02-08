import XCTest
import SwiftHamcrest
import Parsing
import Foundation

class Day8Test: XCTestCase {
 
  // 602, 983, 1249 is too low 1375 is wrong
  func testPart1() throws {
    let contents = try String(contentsOfFile: Bundle(for: type(of: self)).path(forResource: "Day8Resources", ofType: "txt")!, encoding: .utf8).lines.filter{ !$0.isEmpty }
    
    assertThat(getDiff(contents: contents) == 1371)
  }
  
  func testPart1Test() throws {
    let contents = try String(contentsOfFile: Bundle(for: type(of: self)).path(forResource: "Day8ResourcesTest", ofType: "txt")!, encoding: .utf8).lines.filter{ !$0.isEmpty }
    
    assertThat(getDiff(contents: contents) == 15)
  }
  
  func getDiff(contents: [String]) -> Int {
    let totalNumberOfChars = contents.map{ $0.count }.reduce(.zero, +)
    let memoryChars = contents
      .map{ $0.replacingOccurrences(of: #"\\[x][A-Fa-f0-9][A-Fa-f0-9]"#, with: "0", options: .regularExpression) }
      .map{ $0.replacingOccurrences(of: #"\\""#, with: "1", options: .regularExpression) }
      .map{ $0.replacingOccurrences(of: #"\\\\"#, with: "2", options: .regularExpression) }
    let totalNumberOfMemoryChars = memoryChars.map{ $0.count-2 }.reduce(.zero, +)
    
    print("values = \(memoryChars.map{ $0.count-2 })")
    
    return totalNumberOfChars-totalNumberOfMemoryChars
  }
}
