import Foundation

@Observable
class MyPageViewModel {
  var posts: [Post] = []

  private let useCase: MyPageUseCaseProtocol

  init(useCase: MyPageUseCaseProtocol) {
    self.useCase = useCase
  }

  func pullToRefresh(user: User?) async {
    guard let userID = user?.id else { return }
    await fetch(userID: userID)
  }

  func onAppear(user: User?) async {
    guard posts.isEmpty else { return }
    guard let userID = user?.id else { return }
    await fetch(userID: userID)
  }

  func fetch(userID: String) async {
    do {
      posts = try await useCase.fetch(userID: userID)
      let user = try await useCase.fetchSelf(userID: userID)
      Task { @MainActor in
        AppEnvironment.shared.user = user
      }
    } catch {
      print(error.localizedDescription)
    }
  }

  func didTapDelete(id: String) async {
    do {
      try await useCase.delete(postID: id)
      posts.removeAll(where: { $0.id == id })
    } catch {
      print(error.localizedDescription)
    }
  }

}
