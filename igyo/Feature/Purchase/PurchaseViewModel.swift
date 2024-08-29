import Foundation
import StoreKit

@Observable
class PurchaseViewModel {
  var products: [Product] = []
  var errorMessage: String?

  private let useCase: any PurchaseUseCaseProtocol

  init(useCase: any PurchaseUseCaseProtocol) {
    self.useCase = useCase
  }

  func onAppear() async {
    do {
      products = try await useCase.fetchAll()
    } catch {
      print(error.localizedDescription)
      errorMessage = error.localizedDescription
    }
  }

  func purchaseComplete(uid: String?) async {
    guard let uid else { return }
    do {
      try await useCase.purchaseComplete(uid: uid)
    } catch {
      print(error.localizedDescription)
    }
  }
}
