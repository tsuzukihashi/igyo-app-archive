import Foundation

enum SubscribeError: LocalizedError {
  case userCancelled
  case pending
  case productUnavailable
  case purchaseNotAllowed
  case failedVerification
  case otherError

  var errorDescription: String? {
    switch self {
    case .userCancelled:
      "ユーザーによって購入がキャンセルされました"
    case .pending:
      "購入が保留されています"
    case .productUnavailable:
      "指定した商品が無効です"
    case .purchaseNotAllowed:
      "OSの支払い機能が無効化されています"
    case .failedVerification:
      "トランザクションデータの署名が不正です"
    case .otherError:
      "不明なエラーが発生しました"
    }
  }
}
