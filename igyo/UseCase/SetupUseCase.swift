import Foundation

protocol SetupUseCaseProtocol {
  func fetch() async throws -> [Icon]
  func update(uid: String, icon: Icon, name: String) async throws
}

final class SetupUseCase: SetupUseCaseProtocol {
  private let userService: UserServiceProcotol
  private let iconService: IconServiceProtocol

  init(userService: UserServiceProcotol, iconService: IconServiceProtocol) {
    self.userService = userService
    self.iconService = iconService
  }

  func fetch() async throws -> [Icon] {
    try await iconService.fetch()
  }

  func update(uid: String, icon: Icon, name: String) async throws {
    try await userService.updateUser(id: uid, icon: icon, name: name)
  }
}
