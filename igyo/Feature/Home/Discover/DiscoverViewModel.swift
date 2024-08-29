import Foundation

@Observable
final class DiscoverViewModel {
  var query: String = ""
  var displayUsers: [User] = []

  private let useCase: DiscoverUseCaseProtocol

  init(useCase: DiscoverUseCaseProtocol) {
    self.useCase = useCase
  }

  func pullToRefresh() async {
    await fetch()
  }

  func onAppear() async {
    guard displayUsers.isEmpty else { return }
    await fetch()
  }

  private func fetch() async {

    do {
      displayUsers = try await useCase.fetchDisplayUser().filter { $0.imageUrl != "" }
    } catch {
      print(error.localizedDescription)
    }
  }
}
