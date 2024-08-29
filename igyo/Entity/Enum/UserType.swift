import Foundation

enum UserType: String, Codable {
  case normal
  case suporter
  case ghost
  case unknown

  public init(from decoder: Decoder) throws {
    self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
  }
}
