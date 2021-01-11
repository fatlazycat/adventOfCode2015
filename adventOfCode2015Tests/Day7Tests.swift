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
    case AND(gateOne: String, gateTwo: String, to: String)
    case ONE_AND(gateTwo: String, to: String)
    case OR(gateOne: String, gateTwo: String, to: String)
    case PASSTHROUGH(from: Either<String, Int>, to: String)
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
  
  let andParser = Prefix<Substring>(while: { $0.isLetter })
    .skip(StartsWith(" AND "))
    .take(Prefix(while: { $0.isLetter }))
    .skip(StartsWith(" -> "))
    .take(Rest())
    .map{ Logic.AND(gateOne: String($0), gateTwo: String($1), to: String($2)) }
  
  let oneAndParser = Skip(PrefixThrough<Substring>("1 AND "))
    .take(Prefix(while: { $0.isLetter }))
    .skip(StartsWith(" -> "))
    .take(Rest())
    .map{ Logic.ONE_AND(gateTwo: String($0), to: String($1)) }
  
  let orParser = Prefix<Substring>(while: { $0.isLetter })
    .skip(StartsWith(" OR "))
    .take(Prefix(while: { $0.isLetter }))
    .skip(StartsWith(" -> "))
    .take(Rest())
    .map{ Logic.OR(gateOne: String($0), gateTwo: String($1), to: String($2)) }
    
  let passThroughParser = Int.parser().map{ Either.Right($0) }
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
    assertThat(andParser.parse("ih AND ij -> ik") == Logic.AND(gateOne: "ih", gateTwo: "ij", to: "ik"))
  }
  
  func testOneAndParser() throws {
    assertThat(oneAndParser.parse("1 AND jj -> jk") == Logic.ONE_AND(gateTwo: "jj", to: "jk"))
  }
  
  func testOrParser() throws {
    assertThat(orParser.parse("t OR s -> u") == Logic.OR(gateOne: "t", gateTwo: "s", to: "u"))
  }
  
  func testPassThroughLeftParser() throws {
    assertThat(passThroughParser.parse("lx -> a") == Logic.PASSTHROUGH(from: .Left("lx"), to: "a"))
  }
  
  func testPassThroughRightParser() throws {
    assertThat(passThroughParser.parse("1 -> b") == Logic.PASSTHROUGH(from: .Right(1), to: "b"))
  }
  
  func testPart1() throws {
    let logicParser = notParser
      .orElse(leftShiftParser)
      .orElse(rightShiftParser)
      .orElse(andParser)
      .orElse(oneAndParser)
      .orElse(orParser)
      .orElse(passThroughParser)
    
    let data = day7.lines.map{ logicParser.parse($0)! }
    print(data[0])
    print(data[1])
    print(data[2])
  }
}
