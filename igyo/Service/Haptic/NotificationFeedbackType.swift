import Foundation
import UIKit

enum NotificationFeedbackType: Int {
  case success
  case failure
  case error

  var value: UINotificationFeedbackGenerator.FeedbackType {
    return .init(rawValue: rawValue)!
  }
}
