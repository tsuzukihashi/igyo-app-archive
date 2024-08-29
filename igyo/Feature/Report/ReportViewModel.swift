import Foundation

@Observable
final class ReportViewModel {
  var selected: ReportType?
  private let useCase: ReportUseCaseProtocol

  init(useCase: ReportUseCaseProtocol) {
    self.useCase = useCase
  }

  func didTapSubmitButton(post: Post, user: User?, completion: @escaping () -> Void) async {
    guard let user, let selected else { return }
    do {
      try await useCase.post(type: selected, post: post, user: user)
      completion()
    } catch {
      // TODO: すでに報告済みだとエラーになるから後でハンドリングしてあげても良いかもしれない
      print(error.localizedDescription)
    }
  }
}
