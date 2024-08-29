import Foundation
import UIKit

@Observable
final class CreateViewModel {
  var message: String = ""
  var posting: Bool = false
  var showSuccess: Bool = false
  var showFailure: Bool = false
  var showPhotoSelect: Bool = false
  var showImagePicker: Bool = false
  var showAlbumImagePicker: Bool = false
  var selectedImage: UIImage?
  var category: Category?

  private let useCase: CreateUseCaseProtocol

  init(useCase: CreateUseCaseProtocol) {
    self.useCase = useCase
  }

  func didTapPostButton(user: User?) async {
    defer {
      posting = false
    }

    guard let user else { return }
    posting = true
    let imageData = selectedImage?.compressImage()

    do {
      try await useCase.create(
        user: user,
        message: message,
        imageData: imageData == nil ? [] : [imageData!],
        category: category
      )
      await postSuccess()
      HapticFeedbackManager.shared.play(.impact(.heavy))
    } catch {
      await postFailure()
      print(error.localizedDescription)
    }
  }

  @MainActor
  private func postSuccess() {
    message = ""
    selectedImage = nil
    showSuccess = true
  }

  @MainActor
  private func postFailure() {
    showFailure = true
  }
}
