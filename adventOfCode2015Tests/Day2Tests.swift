
import XCTest
import SwiftHamcrest
import Parsing
import Foundation

class Day2Test: XCTestCase {
  
  let parser = Int.parser()
    .skip(StartsWith("x"))
    .take(Int.parser())
    .skip(StartsWith("x"))
    .take(Int.parser())
    .map{ (width: $0, height: $1, depth: $2) }
  
  func testPart1() throws {
    let data = day2.lines.map{ parser.parse($0)! }
    let areas = data.map { paperNeeded($0) }
    
    assertThat(areas.reduce(0, +) == 1588178)
  }
  
  func testPart2() throws {
    let data = day2.lines.map{ parser.parse($0)! }
    let ribbon = data.map { ribbonNeed($0) }
    
    assertThat(ribbon.reduce(0, +) == 3783758)
  }
  
  func paperNeeded(_ dim: (Int, Int, Int)) -> Int {
    let area = 2*dim.0*dim.2 + 2*dim.0*dim.1 + 2*dim.1*dim.2
    let lowestValues = Array<Int>.fromTuple(dim)!.sorted().prefix(2)
    
    return area + lowestValues[0]*lowestValues[1]
  }
  
  func ribbonNeed(_ dim: (Int, Int, Int)) -> Int {
    let vol = dim.0*dim.1*dim.2
    let lowestValues = Array<Int>.fromTuple(dim)!.sorted().prefix(2)
    let ribbonToWrap = 2*lowestValues[0] + 2*lowestValues[1]
    
    return vol + ribbonToWrap
  }
}
