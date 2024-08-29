import Foundation

protocol NoticeUseCaseProtocol {
  func fetch(postUserID: String) async throws -> [Notice]
  func fetch(actionUserID: String) async throws -> [Notice]
  func fetch(postID: String) async throws -> [Notice]
  func fetchNext(actionUserID: String, createdAt: Date) async throws -> [Notice]
}

final class NoticeUseCase: NoticeUseCaseProtocol {
  private let noticeService: NoticeServiceProtocol

  init(noticeService: NoticeServiceProtocol) {
    self.noticeService = noticeService
  }

  func fetch(postUserID: String) async throws -> [Notice] {
    try await noticeService.fetch(postUserID: postUserID)
  }  

  func fetch(actionUserID: String) async throws -> [Notice] {
    try await noticeService.fetch(actionUserID: actionUserID)
  }

  func fetchNext(actionUserID: String, createdAt: Date) async throws -> [Notice] {
    try await noticeService.fetch(actionUserID: actionUserID, createdAt: createdAt)
  }

  func fetch(postID: String) async throws -> [Notice] {
    try await noticeService.fetch(postID: postID)
  }
}
