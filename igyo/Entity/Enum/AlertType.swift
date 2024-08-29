import Foundation

enum AlertType {
  case defaultError(viewData: DefaultErrorViewData)
  case multipleButtonError(viewData: MultipleButtonErrorViewData)
}

struct DefaultErrorViewData {
  let title: String
  let message: String
  let buttonText: String
  let handler: (() -> Void)?
}

struct MultipleButtonErrorViewData {
  let title: String
  let message: String
  let primaryButtonText: String
  let secondaryButtonText: String
  let primaryButtonHandler: (() -> Void)?
  let secondaryButtonHandler: (() -> Void)?
}

extension AlertType {
  var isDefaultError: Bool {
    switch self {
    case .defaultError:
      return true
    default:
      return false
    }
  }

  var isMultipleButtonError: Bool {
    switch self {
    case .multipleButtonError:
      return true
    default:
      return false
    }
  }
}
