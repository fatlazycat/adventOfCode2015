import XCTest
import SwiftHamcrest
import Parsing
import Foundation

class Day5Test: XCTestCase {
  func testPart1() {
    let data = day5.lines
    let niceStrings = data.filter{ checkString($0) }.count
    assertThat(niceStrings == 236)
  }
  
  func testPart1Test() {
    assertThat(checkString("ugknbfddgicrmopn") == true)
    assertThat(checkString("aaa") == true)
    assertThat(checkString("jchzalrnumimnmhp") == false)
    assertThat(checkString("haegwjzuvuyypxyu") == false)
    assertThat(checkString("dvszwmarrgswjxmb") == false)
  }
  
  func testPart2() {
    let data = day5.lines
    let niceStrings = data.filter{ checkStringPart2($0) }.count
    assertThat(niceStrings == 51)
  }
  
  func testPart2Test() {
    assertThat(checkStringPart2("aaab") == false)
    assertThat(checkStringPart2("qjhvhtzxzqqjkmpb") == true)
    assertThat(checkStringPart2("xxyxx") == true)
    assertThat(checkStringPart2("uurcxstgmygtbstg") == false)
    assertThat(checkStringPart2("ieodomkazucvgmuy") == false)
  }

  func checkStringPart2(_ s: String) -> Bool {
    return pairOfChars(s)
      && repeatingChars(s)
  }
  
  func pairOfChars(_ s: String) -> Bool {
    let pairs = zip(s, s.dropFirst()).map{(a,b) in String(a) + String(b)}
    let atLeastOne = pairs.groupBy(by: {$0}).filter{$0.value.count > 1}.keys
    let indiciesOfPairs = atLeastOne.map{
      candidate in pairs.enumerated().map{
        candidate == $0.element ? $0.offset : -1
      }.filter{ $0 != -1}
    }
    let goodPairs = indiciesOfPairs.map{
      isGoodPair($0.min(), $0.max())
    }
    
    return goodPairs.contains(true)
  }
  
  fileprivate func isGoodPair(_ min: Int?, _ max: Int?) -> Bool {
    if let min = min, let max = max {
      return max - min > 1
    }
    else {
      return false
    }
  }
  
  func repeatingChars(_ s: String) -> Bool {
    let atLeastOne = s.toCharArray().groupBy(by: {$0}).filter{$0.value.count > 1}.keys
    let indiciesOfRepeats = atLeastOne.map{
      candidate in s.enumerated().map{
        candidate == $0.element ? $0.offset : -1
      }.filter{ $0 != -1}
    }
    let goodRepeats = indiciesOfRepeats.map{
      isGoodRepeat($0)
    }
    
    return goodRepeats.contains(true)
  }

  fileprivate func isGoodRepeat(_ indicies: Array<Int>) -> Bool {
    let candidates = indicies.map{ i in indicies.contains(i+2) }
    
    return candidates.contains(true)
  }
  
  func checkString(_ s: String) -> Bool {
    return containsVowels(s).count >= 3
      && containsDoubleCharactersAtleastOnce(s)
      && doesNotContainsNaughtyString(s)
  }
  
  func containsVowels(_ s: String) -> Array<Character> {
    return s.toCharArray().filter{ "aeiuo".contains($0) }
  }
  
  func containsDoubleCharactersAtleastOnce(_ s: String) -> Bool {
    let chars = s.toCharArray()
    let zipped = zip(chars, chars.dropFirst())
    
    return zipped.filter{ (a,b) in a == b }.count > 0
  }
  
  func doesNotContainsNaughtyString(_ s: String) -> Bool {
    return !s.contains("ab") && !s.contains("cd") && !s.contains("pq") && !s.contains("xy")
  }
}
