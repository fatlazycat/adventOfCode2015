
import XCTest
import SwiftHamcrest
import Parsing
import Foundation

class Day3Test: XCTestCase {
  func testPart1() throws {
    //    let presents = Dictionary(uniqueKeysWithValues: day3.enumerated().map { (index, element) in (1, element) })
    struct Point : Equatable, Hashable {
      let x: Int
      let y: Int
    }
    
    struct Acc {
      let count: [Point]
      let currentLocation: Point
    }
    
    let presents = day3.reduce( Acc(count: [], currentLocation: Point(x: 0, y: 0)),
                                {acc, c in
                                  let newLocation: Point
                                  
                                  switch(c) {
                                  case "^": newLocation = Point(x: acc.currentLocation.x + 1, y: acc.currentLocation.y)
                                  case "v": newLocation = Point(x: acc.currentLocation.x - 1, y: acc.currentLocation.y)
                                  case ">": newLocation = Point(x: acc.currentLocation.x, y: acc.currentLocation.y + 1)
                                  case "<": newLocation = Point(x: acc.currentLocation.x, y: acc.currentLocation.y - 1)
                                  default:
                                    fatalError()
                                  }
                                  
                                  return Acc(count: acc.count + [newLocation], currentLocation: newLocation)
                                })
    let mappedLocations = Dictionary(grouping: presents.count, by: {$0})
    
    assertThat(mappedLocations.keys.count == 2565)
  }
}
