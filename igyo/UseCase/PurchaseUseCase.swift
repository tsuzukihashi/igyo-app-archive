import Foundation
import StoreKit

protocol PurchaseUseCaseProtocol {
  func fetchAll() async throws -> [Product]
  func purchaseComplete(uid: String) async throws
  func observeTransactionUpdates(uid: String)
  func updateSubscriptionStatus(uid: String) async
}

class PurchaseUseCase: PurchaseUseCaseProtocol {
  private let environment: AppEnvironment = .shared
  private let userService: any UserServiceProcotol
  private let purchaseService: any PurchaseServiceProtocol

  init(userService: any UserServiceProcotol, purchaseService: any PurchaseServiceProtocol) {
    self.userService = userService
    self.purchaseService = purchaseService
  }

  func fetchAll() async throws -> [Product] {
    try await purchaseService.fetchAll()
  }

  func purchaseComplete(uid: String) async throws {
    try await userService.updateUser(id: uid, type: .suporter)
    Task { @MainActor in
      environment.user?.type = .suporter
      environment.isPremiumUser = true
    }
  }

  // トランザクションの更新を監視する
  func observeTransactionUpdates(uid: String) {
    Task(priority: .background) {
      for await verificationResult in StoreKit.Transaction.updates {
        guard case .verified(let transaction) = verificationResult else {
          continue
        }

        if transaction.revocationDate != nil {
          // 払い戻しされてるので特典削除
          try? await userService.updateUser(id: uid, type: .normal)
          Task { @MainActor in
            environment.user?.type = .normal
            environment.isPremiumUser = false
          }
        } else if let expirationDate = transaction.expirationDate,
                  Date() < expirationDate // 有効期限内
                    && !transaction.isUpgraded // アップグレードされていない
        {
          // 有効なサブスクリプションなのでproductIdに対応した特典を有効にする
          try? await userService.updateUser(id: uid, type: .suporter)
          Task { @MainActor in
            environment.user?.type = .suporter
            environment.isPremiumUser = true
          }
        }

        await transaction.finish()
      }
    }
  }

  // 購入状況の変化を反映する
  func updateSubscriptionStatus(uid: String) async {
    var validSubscription: StoreKit.Transaction?
    for await verificationResult in Transaction.currentEntitlements {
      if case .verified(let transaction) = verificationResult,
         transaction.productType == .autoRenewable && !transaction.isUpgraded {
        validSubscription = transaction
      }
    }

    if (validSubscription?.productID) != nil {
      // 特典を付与
      try? await userService.updateUser(id: uid, type: .suporter)
      Task { @MainActor in
        environment.user?.type = .suporter
        environment.isPremiumUser = true
      }
    } else {
      // 特典を削除
      try? await userService.updateUser(id: uid, type: .normal)
      Task { @MainActor in
        environment.user?.type = .normal
        environment.isPremiumUser = false
      }
    }
  }

}
