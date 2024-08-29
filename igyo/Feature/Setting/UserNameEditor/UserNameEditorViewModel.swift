import Foundation

@Observable
class UserNameEditorViewModel {
  var name: String = ""
  var validationMessage = ""
  var alertViewData: DefaultErrorViewData?

  private let useCase: UserNameUseCaseProtocol

  init(useCase: UserNameUseCaseProtocol) {
    self.useCase = useCase
  }

  func onAppear(user: User?) {
    name = user?.name ?? ""
  }

  func onChange() {
    validationMessage = useCase.validate(name: name)
  }

  func didTapSubmitButton(user: User?, completion: @escaping () -> Void) async {
    guard let userID = user?.id else { return }
    do {
      try await useCase.change(id: userID, name: name)
      completion()
    } catch {
      print(error.localizedDescription)
    }
  }
}
