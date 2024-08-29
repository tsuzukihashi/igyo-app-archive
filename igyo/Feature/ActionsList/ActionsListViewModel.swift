import SwiftUI

@Observable
class ActionsListViewModel {
  var notices: [Notice] = []
  let noticeUseCase: any NoticeUseCaseProtocol

  init(noticeUseCase: any NoticeUseCaseProtocol) {
    self.noticeUseCase = noticeUseCase
  }

  func onAppear(userID: String) async {
    do {
      notices = try await noticeUseCase.fetch(actionUserID: userID).removeDuplicates(keyPath: \.postID)
    } catch {
      print(error.localizedDescription)
    }
  }

  func nextFetchIfNeeded(notice: Notice) async {
    guard notices.last?.id == notice.id else { return }
    do {
      notices += try await noticeUseCase.fetchNext(actionUserID: notice.actionUserID,  createdAt: notice.createdAt)
      notices = notices.removeDuplicates(keyPath: \.postID)
    } catch {
      print(error.localizedDescription)
    }
  }

}
