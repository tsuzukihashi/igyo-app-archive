import GoogleMobileAds

final class AppOpenAd: NSObject, GADFullScreenContentDelegate {
  static let shared: AppOpenAd = .init()
  private override init() {}
  var appOpenAd: GADAppOpenAd?
  func requestAppOpenAd() {
    let request = GADRequest()
    let unitId: String
#if DEBUG
    unitId = "ca-app-pub-3940256099942544/5662855259"
#else
    unitId = ""
#endif

    GADAppOpenAd.load(
      withAdUnitID: unitId,
      request: request,
      orientation: .portrait,
      completionHandler: { [weak self] (openAd, _) in
        guard let self = self else { return }
        self.appOpenAd = openAd
        self.appOpenAd?.fullScreenContentDelegate = self
        self.presentLaunchAd()
      }
    )
  }

  private func presentLaunchAd() {
    guard let openAd = appOpenAd,
          let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let rootVC = windowScene.windows.first?.rootViewController else { return }
    openAd.present(fromRootViewController: rootVC)
  }
}
