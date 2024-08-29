import SwiftUI
import StoreKit

struct PurchaseView: View {
  @AppStorage("isPremiumUser")
  var isPremiumUser: Bool = false
  @EnvironmentObject var environment: AppEnvironment
  @State var model: PurchaseViewModel = .init(
    useCase: PurchaseUseCase(
      userService: UserService(),
      purchaseService: PurchaseService()
    )
  )
  @State private var isPresentingAlert = false
  @State private var message = ""
  @State private var requesting: Bool = false

  var body: some View {
    SubscriptionStoreView(subscriptions: model.products)
      .overlay {
        if requesting {
          ZStack {
            Color.black.opacity(0.3)
              .ignoresSafeArea()

            ProgressView()
          }
        }
      }
      .subscriptionStoreButtonLabel(.multiline)
      .storeButton(.visible, for: .restorePurchases)
      .storeButton(.visible, for: .redeemCode)
      .subscriptionStorePolicyDestination(url: URL(string: "https://tsuzuki817.notion.site/326c43c324ec4ae187fb67d03bbca5fe")!, for: .privacyPolicy)
      .subscriptionStorePolicyDestination(url: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!, for: .termsOfService)
      .task {
        await model.onAppear()
      }
      .background(Color.baseBackGround)
      .onInAppPurchaseStart { product in
        message = "\(product.displayName)の購入を開始します。"
        isPresentingAlert = true
        requesting = true
      }
      .onInAppPurchaseCompletion { product, result in
        requesting = false
        switch result {
        case .success(let purchaseResult):
          switch purchaseResult {
          case .success(let transaction):
            switch transaction {
            case .verified:
              Task {
                await model.purchaseComplete(uid: environment.user?.id)
              }
              message = "\(product.displayName)の購入に成功しました。"
              isPresentingAlert = true
            case .unverified:
              message = "トランザクションデータの署名が不正です"
              isPresentingAlert = true
            }
          case .pending:
            message = "購入が保留されています"
            isPresentingAlert = true
          case .userCancelled:
            message = "ユーザーによって購入がキャンセルされました"
            isPresentingAlert = true
          @unknown default:
            message = "不明なエラーが発生しました"
            isPresentingAlert = true
          }

        case .failure(let error):
          message = "\(error.localizedDescription)\(product.displayName)の購入に失敗しました。"
          isPresentingAlert = true
        }
      }
      .alert(isPresented: $isPresentingAlert) {
        Alert(title: Text(message),
              dismissButton: .default(Text("OK")))
      }
  }
}

#Preview {
  PurchaseView()
}
