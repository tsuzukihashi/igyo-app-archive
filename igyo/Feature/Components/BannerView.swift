import SwiftUI
import GoogleMobileAds

enum BannerType {
  case home
  case setting

  var id: String {
    switch self {
    case .home:
      return ""
    case .setting:
      return ""
    }
  }
}

struct BannerView: UIViewRepresentable {
  private let type: BannerType

  init(type: BannerType) {
    self.type = type
  }

  func makeUIView(context: Context) -> GADBannerView {
    let view = GADBannerView(adSize: GADAdSizeBanner)
#if DEBUG
    view.adUnitID = "ca-app-pub-3940256099942544/2934735716"
#else
    view.adUnitID = type.id
#endif

    let request = GADRequest()
    let extras = GADExtras()
    extras.additionalParameters = ["collapsible": "bottom"]
    request.register(extras)

    view.load(request)

    let scenes = UIApplication.shared.connectedScenes
    let windowScene = scenes.first as? UIWindowScene
    let window = windowScene?.windows.first
    view.rootViewController = window?.rootViewController
    view.load(GADRequest())
    return view
  }

  func updateUIView(_ uiView: GADBannerView, context: Context) {
  }
}
