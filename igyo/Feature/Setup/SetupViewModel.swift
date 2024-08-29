import Foundation

@Observable
class SetupViewModel {
  private let useCase: SetupUseCaseProtocol
  var icons: [Icon] = []
  var selectedIcon: Icon?
  var name = ""

  init(useCase: SetupUseCaseProtocol) {
    self.useCase = useCase
  }

  func onAppear() async {
    do {
      let result = try await useCase.fetch()
      selectedIcon = result.randomElement()
      icons = result
    } catch {
      print(error.localizedDescription)
    }
  }

  func didTapIcon(icon: Icon) {
    selectedIcon = icon
  }

  func didTapSubmitButton(uid: String?) async {
    guard let uid, let icon = selectedIcon else { return }
    do {
      try await useCase.update(uid: uid, icon: icon, name: name)
    } catch {
      print(error.localizedDescription)
    }
  }
}
