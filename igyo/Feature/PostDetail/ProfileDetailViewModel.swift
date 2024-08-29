import Foundation

@Observable
final class ProfileDetailViewModel {
  var notice: [Notice] = []

  private let noticeUseCase: NoticeUseCaseProtocol

  init(noticeUseCase: NoticeUseCaseProtocol) {
    self.noticeUseCase = noticeUseCase
  }

  func onAppear(post: Post) async {
    guard notice.isEmpty else { return }
    await fetch(post: post)
  }

  private func fetch(post: Post) async {
    do {
      notice = try await noticeUseCase.fetch(postID: post.id)
    } catch {
      print(error.localizedDescription)
    }
  }
}
