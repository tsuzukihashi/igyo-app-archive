import Foundation

protocol PremiumIconEditorUseCaseProtocol {
  func changeIcon(user: User, imageData: Data) async throws
}

final class PremiumIconEditorUseCase: PremiumIconEditorUseCaseProtocol {
  private let userService: UserServiceProcotol
  private let imageService: ImageServiceProtocol

  init(
    userService: UserServiceProcotol,
    imageService: ImageServiceProtocol
  ) {
    self.userService = userService
    self.imageService = imageService
  }

  func changeIcon(user: User, imageData: Data) async throws {
    guard let uid = user.id else { return }
    guard let uploadedImageURL = try await imageService.upload(
      data: imageData,
      type: .user(id: uid)
    ) else { return }

    try await userService.updateUser(id: uid, imageURL: uploadedImageURL.absoluteString)
    Task { @MainActor in
      AppEnvironment.shared.user?.imageUrl = uploadedImageURL.absoluteString
    }
  }
}
