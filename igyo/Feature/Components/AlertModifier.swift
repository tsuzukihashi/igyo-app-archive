import SwiftUI

struct AlertModifier: ViewModifier {
  @Binding var alertType: AlertType?

  var isPresentedDefaultError: Binding<Bool> {
    Binding<Bool>(
      get: { alertType?.isDefaultError ?? false },
      set: {
        if !$0 {
          alertType = nil
        }
      }
    )
  }

  var isPresentedMultopleButtonError: Binding<Bool> {
    Binding<Bool>(
      get: { alertType?.isMultipleButtonError ?? false },
      set: {
        if !$0 {
          alertType = nil
        }
      }
    )
  }

  func body(content: Content) -> some View {
    content
      .alert(
        defaultErrorViewData?.title ?? "エラー",
        isPresented: isPresentedDefaultError
      ) {
        Button(defaultErrorViewData?.buttonText ?? "OK") {
          defaultErrorViewData?.handler?()
          alertType = nil
        }
      } message: {
        Text(defaultErrorViewData?.message ?? "")
      }
      .alert(
        multipleButtonErrorViewData?.title ?? "エラー",
        isPresented: isPresentedMultopleButtonError
      ) {
        Button(multipleButtonErrorViewData?.secondaryButtonText ?? "キャンセル") {
          multipleButtonErrorViewData?.secondaryButtonHandler?()
          alertType = nil
        }
        Button(multipleButtonErrorViewData?.primaryButtonText ?? "OK") {
          multipleButtonErrorViewData?.primaryButtonHandler?()
          alertType = nil
        }
      } message: {
        Text(multipleButtonErrorViewData?.message ?? "")
      }
  }
}

extension AlertModifier {
  var defaultErrorViewData: DefaultErrorViewData? {
    switch alertType {
    case .defaultError(let viewData):
      return viewData
    default:
      return nil
    }
  }

  var multipleButtonErrorViewData: MultipleButtonErrorViewData? {
    switch alertType {
    case .multipleButtonError(let viewData):
      return viewData
    default:
      return nil
    }
  }
}
