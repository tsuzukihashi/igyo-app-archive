import Foundation
import UIKit

@Observable
class PremiumIconEditorViewModel {
  var showPhotoSelect: Bool = false
  var showImagePicker: Bool = false
  var showAlbumImagePicker: Bool = false
  var selectedImage: UIImage?

  var showMessage: Bool = false
  var message: String = ""

  private let userCase: any PremiumIconEditorUseCaseProtocol

  init(userCase: any PremiumIconEditorUseCaseProtocol) {
    self.userCase = userCase
  }

  func update(user: User?) async {
    guard let user, let data = selectedImage?.compressImage() else { return }
    do {
      try await userCase.changeIcon(user: user, imageData: data)
      showMessage(msg: "成功しました")
    } catch {
      print(error.localizedDescription)
      showMessage(msg: "失敗しました")
    }
  }

  func showMessage(msg: String) {
    message = msg
    showMessage = true
  }
}
