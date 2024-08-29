import Foundation

public extension Sequence where Element: Equatable {
  func removeDuplicates<T: Hashable>(keyPath: KeyPath<Element, T>) -> [Element] {
    var seen = Set<T>()
    return filter { (element) -> Bool in
      guard !seen.contains(element[keyPath: keyPath]) else {
        return false
      }
      seen.insert(element[keyPath: keyPath])
      return true
    }
  }
}
