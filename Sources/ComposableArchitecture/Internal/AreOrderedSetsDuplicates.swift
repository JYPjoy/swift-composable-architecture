import Foundation
import OrderedCollections

@inlinable
func areOrderedSetsDuplicates<T>(_ lhs: OrderedSet<T>, _ rhs: OrderedSet<T>) -> Bool {
  var lhs = lhs
  var rhs = rhs
  return lhs.count == rhs.count
    && memcmp(&lhs, &rhs, MemoryLayout<T>.size) == 0 || lhs == rhs
}
