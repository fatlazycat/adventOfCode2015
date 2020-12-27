
import XCTest
import SwiftHamcrest
import Parsing
import Foundation

class Day3Test: XCTestCase {
  struct Point : Equatable, Hashable {
    let x: Int
    let y: Int
  }
  
  struct Acc {
    let count: [Point]
    let currentLocation: Point
  }
  
  fileprivate func getPath(path: String) -> Day3Test.Acc {
    return path.reduce( Acc(count: [], currentLocation: Point(x: 0, y: 0)),
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
  }
  
  func testPart1() throws {
    let presents = getPath(path: day3)
    let mappedLocations = presents.count.groupBy(by: {$0})
    
    assertThat(mappedLocations.keys.count == 2565)
  }
  
  func testPart2() throws {
    let santaPath = stride(from: 0, to: day3.count, by: 2).map { day3[$0] }.toString()
    let robotSantaPath = stride(from: 1, to: day3.count, by: 2).map { day3[$0] }.toString()
    let santaPresents = getPath(path: santaPath)
    let robotSantaPresents = getPath(path: robotSantaPath)
    let mappedLocations = (santaPresents.count + robotSantaPresents.count).groupBy(by: {$0})
    
    assertThat(mappedLocations.keys.count == 2639)
  }
}
