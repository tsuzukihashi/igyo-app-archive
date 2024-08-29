import Foundation

@Observable
final class SettingViewModel {
  private let useCase: SettingUseCaseProtocol

  init(useCase: SettingUseCaseProtocol) {
    self.useCase = useCase
  }

  func didTapSignOut() {
    do {
      try useCase.signOut()
    } catch {
      print(error.localizedDescription)
    }
  }

  func didTapWithdrawal(completion: @escaping () -> Void) async {
    do {
      try await useCase.withdrawal()
      completion()
    } catch {
      print(error.localizedDescription)
    }
  }
}
