import Foundation

protocol IconEditorUseCaseProtocol {
  func fetch() async throws -> [Icon]
  func update(uid: String, icon: Icon) async throws

}

final class IconEditorUseCase: IconEditorUseCaseProtocol {
  private let userService: UserServiceProcotol
  private let iconService: IconServiceProtocol

  init(userService: UserServiceProcotol, iconService: IconServiceProtocol) {
    self.userService = userService
    self.iconService = iconService
  }

  func fetch() async throws -> [Icon] {
    try await iconService.fetch()
  }

  func update(uid: String, icon: Icon) async throws {
    try await userService.updateUser(id: uid, icon: icon)
  }
}
