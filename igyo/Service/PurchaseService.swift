import StoreKit

protocol PurchaseServiceProtocol {
  func fetchAll() async throws -> [Product]
  func purchase(product: Product) async throws -> Transaction
}

struct PurchaseService: PurchaseServiceProtocol {
  private let productIdList = [
    PremiumProductType.month.id, PremiumProductType.year.id
  ]

  func fetchAll() async throws -> [Product] {
    try await Product.products(for: productIdList)
  }

  func purchase(product: Product) async throws -> Transaction {
    // Product.PurchaseResultの取得
    let purchaseResult: Product.PurchaseResult
    do {
      purchaseResult = try await product.purchase()
    } catch Product.PurchaseError.productUnavailable {
      throw SubscribeError.productUnavailable
    } catch Product.PurchaseError.purchaseNotAllowed {
      throw SubscribeError.purchaseNotAllowed
    } catch {
      throw SubscribeError.otherError
    }

    // VerificationResultの取得
    let verificationResult: VerificationResult<Transaction>
    switch purchaseResult {
    case .success(let result):
      verificationResult = result
    case .userCancelled:
      throw SubscribeError.userCancelled
    case .pending:
      throw SubscribeError.pending
    @unknown default:
      throw SubscribeError.otherError
    }

    // Transactionの取得
    switch verificationResult {
    case .verified(let transaction):
      return transaction
    case .unverified:
      throw SubscribeError.failedVerification
    }
  }
}
