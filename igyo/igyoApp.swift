import SwiftUI
import SwiftData
import AppTrackingTransparency

@main
struct igyoApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  let environment: AppEnvironment = .shared
  let appOpenAd: AppOpenAd = .shared

  var sharedModelContainer: ModelContainer = {
    let schema = Schema([
      Item.self,
      CachedCategory.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

    do {
      return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()

  init() {
    environment.launchCount += 1
  }

  var body: some Scene {
    WindowGroup {
      RootView()
        .tint(.primary)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
          ATTrackingManager.requestTrackingAuthorization(completionHandler: { _ in
            if !environment.isPremiumUser {
              showAd()
            }
          })
        }

    }
    .modelContainer(sharedModelContainer)
    .environmentObject(environment)
  }

  private func showAd() {
#if DEBUG
    appOpenAd.requestAppOpenAd()
#else
    appOpenAd.requestAppOpenAd()
#endif
  }
}
