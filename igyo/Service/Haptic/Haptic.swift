import Foundation
import UIKit

enum Haptic {
  case impact(_ style: ImpactFeedbackStyle, intensity: CGFloat? = nil)
  case notification(_ type: NotificationFeedbackType)
}

/**
 - usage
 HapticFeedbackManager.shared.play(.impact(.heavy))
 */
final class HapticFeedbackManager {
  static let shared = HapticFeedbackManager()
  private init() {}
  private var impactFeedbackGenerator: UIImpactFeedbackGenerator?
  private var notificationFeedbackGenerator: UINotificationFeedbackGenerator?

  func play(_ haptic: Haptic) {
    switch haptic {
    case .impact(let style, let intensity):
      impactFeedbackGenerator = UIImpactFeedbackGenerator(style: style.value)
      impactFeedbackGenerator?.prepare()

      if let intensity = intensity {
        impactFeedbackGenerator?.impactOccurred(intensity: intensity)
      } else {
        impactFeedbackGenerator?.impactOccurred()
      }
      impactFeedbackGenerator = nil

    case .notification(let type):
      notificationFeedbackGenerator = UINotificationFeedbackGenerator()
      notificationFeedbackGenerator?.prepare()
      notificationFeedbackGenerator?.notificationOccurred(type.value)
      notificationFeedbackGenerator = nil
    }
  }
}
