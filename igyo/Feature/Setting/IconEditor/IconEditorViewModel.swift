import Foundation

@Observable
final class IconEditorViewModel {
  private let useCase: IconEditorUseCaseProtocol

  var icons: [Icon] = []
  var selectedIcon: Icon?

  init(useCase: IconEditorUseCaseProtocol) {
    self.useCase = useCase
  }

  func onAppear(iconID: String?) async {
    guard let iconID else { return }
    do {
      let result = try await useCase.fetch()
      selectedIcon = result.first(where: { $0.id == iconID })
      icons = result
    } catch {
      print(error.localizedDescription)
    }
  }

  func didTapIcon(icon: Icon) {
    selectedIcon = icon
  }

  func didTapSubmitButton(uid: String?, completion: @escaping () -> Void) async {
    guard let uid, let icon = selectedIcon else { return }
    do {
      try await useCase.update(uid: uid, icon: icon)
      completion()
    } catch {
      print(error.localizedDescription)
    }
  }
}
