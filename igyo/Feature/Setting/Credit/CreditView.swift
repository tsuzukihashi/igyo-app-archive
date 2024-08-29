import SwiftUI

struct CreditView: View {
    var body: some View {
      List {
        Section("ファーストパーティフレームワーク") {
          Link("AppTrackingTransparency", destination: URL(string: "https://developer.apple.com/documentation/apptrackingtransparency/")!)
          Link("AuthenticationServices", destination: URL(string: "https://developer.apple.com/documentation/authenticationservices/")!)
          Link("Combine", destination: URL(string: "https://developer.apple.com/documentation/combine/")!)
          Link("CryptoKit", destination: URL(string: "https://developer.apple.com/documentation/cryptokit/")!)
          Link("Foundation", destination: URL(string: "https://developer.apple.com/documentation/foundation/")!)
          Link("SwiftData", destination: URL(string: "https://developer.apple.com/documentation/swiftdata/")!)
          Link("SwiftUI", destination: URL(string: "https://developer.apple.com/documentation/swiftui/")!)
          Link("UIKit", destination: URL(string: "https://developer.apple.com/documentation/uikit/")!)
        }
        Section("サードパーティフレームワーク") {
          Link("noppefoxwolf@AnimatedImage", destination: URL(string: "https://github.com/noppefoxwolf/AnimatedImage")!)
          Link("firebase@firebase-ios-sdk", destination: URL(string: "https://github.com/firebase/firebase-ios-sdk")!)
          Link("kean@Nuke", destination: URL(string: "https://github.com/kean/Nuke")!)
          Link("airbnb@lottie-spm", destination: URL(string: "https://github.com/airbnb/lottie-spm")!)
          Link("google@GoogleSignIn-iOS", destination: URL(string: "https://github.com/google/GoogleSignIn-iOS")!)
          Link("googleads@swift-package-manager-google-mobile-ads", destination: URL(string: "https://github.com/googleads/swift-package-manager-google-mobile-ads")!)
          Link("tsuzukihashi@ImagePickerSwiftUI", destination: URL(string: "https://github.com/tsuzukihashi/ImagePickerSwiftUI")!)
          Link("Jake-Short@swiftui-image-viewer", destination: URL(string: "https://github.com/Jake-Short/swiftui-image-viewer")!)
        }
      }
      .navigationTitle("クレジット")
      .navigationBarTitleDisplayMode(.inline)
      .tint(.primary)
      .scrollContentBackground(.hidden)
      .background(Color(.baseBackGround))
      .toolbarBackground(Color(.baseBackGround), for: .navigationBar)
    }
}

#Preview {
    CreditView()
}
