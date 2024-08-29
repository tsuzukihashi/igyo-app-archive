import Foundation

@Observable
final class NoticeViewModel {
  var notices: [Notice] = []

  private let useCase: NoticeUseCaseProtocol

  init(useCase: NoticeUseCaseProtocol) {
    self.useCase = useCase
  }

  func pullToRefresh(uid: String?) async {
    guard let uid else { return }
    await fetch(uid: uid)
  }

  func onAppear(uid: String?) async {
    guard notices.isEmpty else { return }

    guard let uid else { return }
    await fetch(uid: uid)
  }

  private func fetch(uid: String) async {
    do {
      notices = try await useCase.fetch(postUserID: uid)
    } catch {
      print(error.localizedDescription)
    }
  }
}
