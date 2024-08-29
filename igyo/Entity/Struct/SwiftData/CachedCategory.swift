import Foundation
import SwiftData

@Model
final class CachedCategory {
  var title: String
  var english: String
  var code: String
  var index: Int

  init(title: String, english: String, code: String, index: Int) {
    self.title = title
    self.english = english
    self.code = code
    self.index = index
  }

  func convert() -> Category {
    .init(title: title, english: english, code: code, index: index)
  }
}
