import Foundation
import SwiftUI

@Observable
class RootViewModel {
  private let authService: any AuthServiceProtocol
  private let userService: any UserServiceProcotol
  private let purchaseUseCase: any PurchaseUseCaseProtocol

  init(
    authService: any AuthServiceProtocol,
    userService: any UserServiceProcotol,
    purchaseUseCase: any PurchaseUseCaseProtocol
  ) {
    self.authService = authService
    self.userService = userService
    self.purchaseUseCase = purchaseUseCase
  }

  func onAppear(uid: String?) {
    guard let uid else { return }
    purchaseUseCase.observeTransactionUpdates(uid: uid)
  }

  func willEnterForegroundNotification(uid: String?) async {
    guard let uid else { return }
    await purchaseUseCase.updateSubscriptionStatus(uid: uid)
  }

  func isLoginUser() -> Bool {
    authService.isLogin
  }

  func fetchMySelfIfNeeded() async -> User? {
    if let id = authService.getCurrentUserID() {
      do {
        return try await userService.fetchUser(id: id)
      } catch {
        print(error.localizedDescription)
      }
    }

    return nil
  }
}
