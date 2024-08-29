import Foundation
import UIKit

enum ImpactFeedbackStyle: Int {
  case light
  case medium
  case heavy
  case soft
  case rigid

  var value: UIImpactFeedbackGenerator.FeedbackStyle {
    return .init(rawValue: rawValue)!
  }
}
