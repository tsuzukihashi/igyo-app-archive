import Foundation

enum PostType: String, Codable {
  case first
  case rookie
  case bronze
  case silver
  case gold
  case platinum
  case diamond
  case master
  case predator
  case unknown

  public init(from decoder: Decoder) throws {
    self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
  }

  static func generate(postCount: Int, reactionCount: Int) -> PostType {
    switch (postCount, reactionCount) {
    case (0, _):
      return .first
    case (1...10, _):
      return .rookie
    default:
      return .unknown
    }
  }
}
