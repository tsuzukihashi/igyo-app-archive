import Foundation

enum PremiumProductType {
  case month
  case year

  var id: String {
    switch self {
    case .month:
      ""
    case .year:
      ""
    }
  }
}
