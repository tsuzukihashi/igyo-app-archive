import Foundation

struct Category: Codable, Equatable, Hashable {
  var title: String
  var english: String
  var code: String
  var index: Int
}

extension Category {
  static var stub: Category {
    .init(title: "日常", english: "everyday", code: "2196F3", index: 12)
  }

  func convert() -> CachedCategory {
    .init(title: title, english: english, code: code, index: index)
  }
}
