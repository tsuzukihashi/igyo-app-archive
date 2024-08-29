import Foundation
import FirebaseRemoteConfig

/// Firebaseのコンソールで設定したパラメータ名に対応
enum ConfigKey: String {
  case forceUpdateVersion = "force_update_version_ios"
  case storeUrl = "app_store_url"

  static func makeDefaults() -> [String: Any] {
    [
      forceUpdateVersion.rawValue: "1.0.0",
      storeUrl.rawValue: ""
    ]
  }
}

protocol RemoteConfigServiceProtocol {
  func fetchConfig() async
  func getConfig(key: ConfigKey) -> RemoteConfigValue
}

class RemoteConfigService: RemoteConfigServiceProtocol {
  private let remoteConfig = RemoteConfig.remoteConfig()
  /// パラメータを取ってくる
  func fetchConfig() async {
    // 取得するパラメータのデフォルトを設定
    remoteConfig.setDefaults(ConfigKey.makeDefaults() as? [String: NSObject])

    do {
      try await remoteConfig.fetchAndActivate()
    } catch {
      print(error.localizedDescription)
    }
  }

  /// RemoteConfigから取ってきたパラメータを取得
  func getConfig(key: ConfigKey) -> RemoteConfigValue {
    remoteConfig.configValue(forKey: key.rawValue)
  }
}
