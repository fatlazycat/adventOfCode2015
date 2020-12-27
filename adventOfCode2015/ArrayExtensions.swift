/**
 # Tuple-to-array for Swift
 
 By Ethan McTague - January 28, 2020
 This source code is in the public domain.
 
 ## Example
 
 To convert a tuple of Ints into an array of ints:
 
 ```
 let ints = (10, 20, 30)
 let result = [Int].fromTuple(ints)
 print(result!) // prints Optional([10, 20, 30])
 ```
 
 */

import Foundation

extension Array {
  
  public func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> [Key:Element] {
    var dict = [Key:Element]()
    for element in self {
      dict[selectKey(element)] = element
    }
    return dict
  }
  
  public func groupBy<Key: Hashable>(by keyForValue: (Self.Element) throws -> Key) rethrows -> Dictionary<Key, [Element]> {
    return try Dictionary(grouping: self, by: keyForValue)
  }
  
  /**
   Attempt to convert a tuple into an Array.
   
   - Parameter tuple: The tuple to try and convert. All members must be of the same type.
   - Returns: An array of the tuple's values, or `nil` if any tuple members do not match the `Element` type of this array.
   */
  static func fromTuple<Tuple>(_ tuple: Tuple) -> [Element]? {
    let val = Array<Element>.fromTupleOptional(tuple)
    return val.allSatisfy({ $0 != nil }) ? val.map { $0! } : nil
  }
  
  /**
   Convert a tuple into an array.
   
   - Parameter tuple: The tuple to try and convert.
   - Returns: An array of the tuple's values, with `nil` for any values that could not be cast to the `Element` type of this array.
   */
  static func fromTupleOptional<Tuple>(_ tuple: Tuple) -> [Element?] {
    return Mirror(reflecting: tuple)
      .children
      .filter { child in
        (child.label ?? "x").allSatisfy { char in ".1234567890".contains(char) }
      }.map { $0.value as? Element }
  }
}
