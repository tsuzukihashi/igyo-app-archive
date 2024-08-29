import Foundation

enum ReportType: String, Codable {
  case username
  case domestic
  case encounter
  case adult
  case missmuch
  case unknown

  static var all: [ReportType] {
    [.username, .domestic, .encounter, .adult, .missmuch]
  }

  public init(from decoder: Decoder) throws {
    self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
  }

  var title: String {
    switch self {
    case .unknown: "不明"
    case .username:
      "ユーザ名が不快"
    case .domestic:
      "暴力的な行為、またはそれを助長している"
    case .encounter:
      "出会いを求める、助長している"
    case .adult:
      "アダルトな内容"
    case .missmuch:
      ":igyo:に好ましくない"
    }
  }
}
