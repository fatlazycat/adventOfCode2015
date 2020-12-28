
import XCTest
import SwiftHamcrest
import Parsing
import Foundation

class Day4Test: XCTestCase {

  let secretKey = "yzbqklnj"
  
  func testPart1() {
//    let answer = findValue(secretKey)
//    assertThat(answer == 282749)
    assertThat((secretKey + "282749").hashed(.md5)!, hasPrefix("00000"))
  }
  
  func testPart2() {
//    let answer = findValue2(secretKey)
//    assertThat(answer == 9962624)
    assertThat((secretKey + "9962624").hashed(.md5)!, hasPrefix("000000"))
  }
  
  func findValue(_ s: String) -> Int {
    for i in 0...10000000 {
      let md5 = (s + String(i)).hashed(.md5)
      if md5?.prefix(5) == "00000" {
        return i
      }
    }
    
    return -1
  }
  
  func findValue2(_ s: String) -> Int {
    for i in 00000000...20000000 {
      let md5 = (s + String(i)).hashed(.md5)
      if md5?.prefix(6) == "000000" {
        return i
      }
    }
    
    return -1
  }
}
