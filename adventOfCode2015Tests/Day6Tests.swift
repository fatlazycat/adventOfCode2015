import XCTest
import SwiftHamcrest
import Parsing
import Foundation

class Day6Test: XCTestCase {
  enum Instruction: Equatable{
    case turnOn
    case turnOff
    case toggle
  }
  
  typealias Point = (x: Int, y: Int)
  
  struct InstructionData {
    let instruction: Instruction
    let lower: Point
    let upper: Point
  }
  
  typealias Input = Slice<UnsafeBufferPointer<UTF8.CodeUnit>>
  
  let instructionParser = StartsWith<Input>("turn on".utf8).map{ Instruction.turnOn }
    .orElse(StartsWith("turn off".utf8).map{ Instruction.turnOff })
    .orElse(StartsWith("toggle".utf8).map{ Instruction.toggle })
    .skip(Whitespace())
    .take(Int.parser())
    .skip(StartsWith(",".utf8))
    .take(Int.parser())
    .skip(StartsWith(" through ".utf8))
    .take(Int.parser())
    .skip(StartsWith(",".utf8))
    .take(Int.parser())
    .map{ InstructionData(instruction: $0, lower: Point($1,$2), upper: Point($3,$4)) }
  
  func testPart1() throws {
    let data = day6.lines.map{ instructionParser.parse($0)! }
    assertThat(numberLit(data: data) == 569999)
  }
  
  func testPart2() throws {
    let data = day6.lines.map{ instructionParser.parse($0)! }
    assertThat(numberLit2(data: data) == 17836115)
  }
  
  func numberLit(data: [InstructionData]) -> Int {
    var arr = Array(repeating: Array(repeating: 0, count: 1000), count: 1000)
    
    for d in data {
      switch d.instruction {
      case .turnOn:
        for x in d.lower.x...d.upper.x {
          for y in d.lower.y...d.upper.y {
            arr[x][y] = 1
          }
        }
        case .turnOff:
          for x in d.lower.x...d.upper.x {
            for y in d.lower.y...d.upper.y {
              arr[x][y] = 0
            }
          }
      case .toggle:
        for x in d.lower.x...d.upper.x {
          for y in d.lower.y...d.upper.y {
            arr[x][y] = arr[x][y] == 1 ? 0 : 1
          }
        }
      }
    }
    
    var total = 0
    for x in 0...999 {
      for y in 0...999 {
        total += arr[x][y]
      }
    }
    
    return total
  }
  
  func numberLit2(data: [InstructionData]) -> Int {
    var arr = Array(repeating: Array(repeating: 0, count: 1000), count: 1000)
    
    for d in data {
      switch d.instruction {
      case .turnOn:
        for x in d.lower.x...d.upper.x {
          for y in d.lower.y...d.upper.y {
            arr[x][y] += 1
          }
        }
        case .turnOff:
          for x in d.lower.x...d.upper.x {
            for y in d.lower.y...d.upper.y {
              arr[x][y] -= arr[x][y] == 0 ? 0 : 1
            }
          }
      case .toggle:
        for x in d.lower.x...d.upper.x {
          for y in d.lower.y...d.upper.y {
            arr[x][y] += 2
          }
        }
      }
    }
    
    var total = 0
    for x in 0...999 {
      for y in 0...999 {
        total += arr[x][y]
      }
    }
    
    return total
  }
}

