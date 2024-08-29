import Combine
import UIKit
import FirebaseRemoteConfig

final class UpdateCheckManager {
  static let shared = UpdateCheckManager()
  private var remoteConfigService: RemoteConfigServiceProtocol?
  private var cancellable: AnyCancellable?

  private init() {}

  func setup() {
    remoteConfigService = RemoteConfigService()
    observeApplicationDidBecomeActive()
  }

  private func observeApplicationDidBecomeActive() {
    cancellable = NotificationCenter.Publisher(
      center: .default,
      name: UIApplication.didBecomeActiveNotification,
      object: nil
    )
    .sink(receiveValue: { [weak self] _ in
      guard let self else { return }
      Task {
        await self.remoteConfigService?.fetchConfig()
        self.forceUpdateIfNeeded()
      }
    })
  }

  private func forceUpdateIfNeeded() {
    let forceUpdateVersion = remoteConfigService?.getConfig(key: .forceUpdateVersion).stringValue
    let currentVersionString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String

    if let currentVersionString,
       forceUpdateVersion != currentVersionString {
      guard
        let storeUrlString = remoteConfigService?.getConfig(key: .storeUrl).stringValue,
        storeUrlString == "",
        let storeUrl = URL(string: storeUrlString)
      else {
        return
      }

      Task { @MainActor in
         AppEnvironment.shared.showForceUpdate = true
         AppEnvironment.shared.storeURL = storeUrl
      }
    }
  }
}
