import Foundation

enum ActionType: String, Codable {
  case igyo
  case suteki
  case kusa
  case welcome
  case sugoi
  case go
  case kansya
  case saikyo
  case appare
  case tensai
  case erai
  case iine
  case otsukare
  case sonkei
  case wakaru
  case unknown

  public init(from decoder: Decoder) throws {
    self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
  }

  static var all: [ActionType] {
    [
      .igyo, .suteki, .sugoi, .kusa, .welcome,
      .go, .kansya, .saikyo, .appare, .tensai,
      .erai, .iine, .otsukare, .sonkei, .wakaru
    ]
  }

  var imageName: String {
    switch self {
    case .igyo:
      "igyo"
    case .suteki:
      "suteki"
    case .kusa:
      "kusa"
    case .welcome:
      "welcome"
    case .sugoi:
      "sugoi"
    case .go:
      "go"
    case .kansya:
      "kansya"
    case .saikyo:
      "saikyo"
    case .appare:
      "appare"
    case .tensai:
      "tensai"
    case .unknown:
      "unknown"
    case .erai:
      "erai"
    case .iine:
      "iine"
    case .otsukare:
      "otsukare"
    case .sonkei:
      "sonkei"
    case .wakaru:
      "wakaru"
    }
  }
}
