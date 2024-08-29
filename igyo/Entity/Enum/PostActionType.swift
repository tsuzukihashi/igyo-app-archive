import Foundation

enum PostActionType: String, Codable {
  case delete
  case report
  case hidden
  case unknown

  public init(from decoder: Decoder) throws {
    self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
  }
}
