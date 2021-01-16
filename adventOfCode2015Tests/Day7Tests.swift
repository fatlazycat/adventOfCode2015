import XCTest
import SwiftHamcrest
import Parsing
import Foundation

class Day7Test: XCTestCase {
  enum Either<A, B>: Equatable where A: Equatable, B: Equatable {
    case Left(A)
    case Right(B)
    
    static func from(_ a: A) -> Either {
      return .Left(a)
    }
    
    static func from(_ b: B) -> Either {
      return .Right(b)
    }
  }
  
  enum Logic: Equatable {
    case NOT(from: String, to: String)
    case LSHIFT(from: String, to: String, shift: Int)
    case RSHIFT(from: String, to: String, shift: Int)
    case AND(gateOne: Either<String, UInt16>, gateTwo: String, to: String)
    case OR(gateOne: String, gateTwo: String, to: String)
    case PASSTHROUGH(from: Either<String, UInt16>, to: String)
    
    func toGate() -> String {
      switch self {
      case .NOT(from: _, to: let to): return to
      case .LSHIFT(from: _, to: let to, shift: _): return to
      case .RSHIFT(from: _, to: let to, shift: _): return to
      case .AND(gateOne: _, gateTwo: _, to: let to): return to
      case .OR(gateOne: _, gateTwo: _, to: let to): return to
      case .PASSTHROUGH(from: _, to: let to): return to
      }
    }
  }
  
  let notParser = Skip(PrefixThrough<Substring>("NOT "))
    .take(Prefix(while: { $0.isLetter }))
    .skip(StartsWith(" -> "))
    .take(Rest())
    .map{ Logic.NOT(from: String($0), to: String($1)) }
  
  let leftShiftParser = Prefix<Substring>(while: { $0.isLetter })
    .skip(StartsWith(" LSHIFT "))
    .take(Int.parser())
    .skip(StartsWith(" -> "))
    .take(Rest())
    .map{ Logic.LSHIFT(from: String($0), to: String($2), shift: $1) }
  
  let rightShiftParser = Prefix<Substring>(while: { $0.isLetter })
    .skip(StartsWith(" RSHIFT "))
    .take(Int.parser())
    .skip(StartsWith(" -> "))
    .take(Rest())
    .map{ Logic.RSHIFT(from: String($0), to: String($2), shift: $1) }
  
  let andParser = Int.parser().map{ Either.Right(UInt16($0)) }
    .orElse(Prefix<Substring>(while: { $0.isLetter }).map{ Either.Left(String($0)) })
    .skip(StartsWith(" AND "))
    .take(Prefix(while: { $0.isLetter }))
    .skip(StartsWith(" -> "))
    .take(Rest())
    .map{ Logic.AND(gateOne: $0, gateTwo: String($1), to: String($2)) }
  
  let orParser = Prefix<Substring>(while: { $0.isLetter })
    .skip(StartsWith(" OR "))
    .take(Prefix(while: { $0.isLetter }))
    .skip(StartsWith(" -> "))
    .take(Rest())
    .map{ Logic.OR(gateOne: String($0), gateTwo: String($1), to: String($2)) }
    
  let passThroughParser = Int.parser().map{ Either.Right(UInt16($0)) }
    .orElse(Prefix<Substring>(while: { $0.isLetter }).map{ Either.Left(String($0)) })
    .skip(StartsWith(" -> "))
    .take(Rest())
    .map{ Logic.PASSTHROUGH(from: $0, to: String($1)) }
  
  func testNotParser() throws {
    assertThat(notParser.parse("NOT jd -> je") == Logic.NOT(from: "jd", to: "je"))
  }
  
  func testLeftShiftParser() throws {
    assertThat(leftShiftParser.parse("hb LSHIFT 1 -> hv") == Logic.LSHIFT(from: "hb", to: "hv", shift: 1))
  }
  
  func testRightShiftParser() throws {
    assertThat(rightShiftParser.parse("fo RSHIFT 3 -> fq") == Logic.RSHIFT(from: "fo", to: "fq", shift: 3))
  }
  
  func testAndParser() throws {
    assertThat(andParser.parse("ih AND ij -> ik") == Logic.AND(gateOne: .Left("ih"), gateTwo: "ij", to: "ik"))
  }
  
  func testOneAndParser() throws {
    assertThat(andParser.parse("1 AND jj -> jk") == Logic.AND(gateOne: .Right(1), gateTwo: "jj", to: "jk"))
  }
  
  func testOrParser() throws {
    assertThat(orParser.parse("t OR s -> u") == Logic.OR(gateOne: "t", gateTwo: "s", to: "u"))
  }
  
  func testPassThroughGateParser() throws {
    assertThat(passThroughParser.parse("lx -> a") == Logic.PASSTHROUGH(from: .Left("lx"), to: "a"))
  }
  
  func testPassThroughNumberParser() throws {
    assertThat(passThroughParser.parse("1 -> b") == Logic.PASSTHROUGH(from: .Right(1), to: "b"))
  }

  func testPart1testdata() throws {
    let logicParser = notParser
      .orElse(leftShiftParser)
      .orElse(rightShiftParser)
      .orElse(andParser)
      .orElse(orParser)
      .orElse(passThroughParser)
    
    let data = day7test.lines.map{ logicParser.parse($0)! }
    let outputGates = data.toDictionary{ $0.toGate() }
    assertThat(resultForGate(gate: "d", gates: outputGates), equalTo(72))
    assertThat(resultForGate(gate: "e", gates: outputGates), equalTo(507))
    assertThat(resultForGate(gate: "f", gates: outputGates), equalTo(492))
    assertThat(resultForGate(gate: "g", gates: outputGates), equalTo(114))
    assertThat(resultForGate(gate: "h", gates: outputGates), equalTo(65412))
    assertThat(resultForGate(gate: "i", gates: outputGates), equalTo(65079))
    assertThat(resultForGate(gate: "x", gates: outputGates), equalTo(123))
    assertThat(resultForGate(gate: "y", gates: outputGates), equalTo(456))
  }
  
  func testPart1() throws {
    let logicParser = notParser
      .orElse(leftShiftParser)
      .orElse(rightShiftParser)
      .orElse(andParser)
      .orElse(orParser)
      .orElse(passThroughParser)
    
    let data = day7.lines.map{ logicParser.parse($0)! }
    let outputGates = data.toDictionary{ $0.toGate() }
    let result = resultForGate(gate: "h", gates: outputGates)
    print("result = \(result)")
  }
  
  func resultForGate(gate: String, gates: Dictionary<String, Logic>) -> UInt16 {
    let logicGate = gates[gate]!
    let result: UInt16
    
    switch logicGate {
    case .NOT(from: let from, to: _):
      result = ~resultForGate(gate: from, gates: gates)
    case .LSHIFT(from: let from, to: _, shift: let shift):
      result = resultForGate(gate: from, gates: gates) << shift
    case .RSHIFT(from: let from, to: _, shift: let shift):
      result = resultForGate(gate: from, gates: gates) >> shift
    case .AND(Either<String, UInt16>.Left(gateOne: let gateOne), gateTwo: let gateTwo, to: _):
      result = resultForGate(gate: gateOne, gates: gates) & resultForGate(gate: gateTwo, gates: gates)
    case .AND(Either<String, UInt16>.Right(gateOne: let gateOne), gateTwo: let gateTwo, to: _):
      result = gateOne & resultForGate(gate: gateTwo, gates: gates)
    case .OR(gateOne: let gateOne, gateTwo: let gateTwo, to: _):
      result = resultForGate(gate: gateOne, gates: gates) | resultForGate(gate: gateTwo, gates: gates)
    case .PASSTHROUGH(Either<String, UInt16>.Left(from: let from), to: _):
      result = resultForGate(gate: from, gates: gates)
    case .PASSTHROUGH(Either<String, UInt16>.Right(from: let from), to: _):
      result = from
    }
    
    return result
  }
}
