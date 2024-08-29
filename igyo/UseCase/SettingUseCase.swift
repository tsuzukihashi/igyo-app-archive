import Foundation

protocol SettingUseCaseProtocol {
  func signOut() throws
  func withdrawal() async throws
}

final class SettingUseCase: SettingUseCaseProtocol {
  private let authService: AuthServiceProtocol

  init(authService: AuthServiceProtocol) {
    self.authService = authService
  }

  func signOut() throws {
    try authService.signOut()
  }

  func withdrawal() async throws {
    try await authService.delete()
  }
}
