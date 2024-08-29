import Foundation

protocol ReportUseCaseProtocol {
  func fetch(userID: String) async throws -> [Report]
  func post(type: ReportType, post: Post, user: User) async throws
}

final class ReportUseCase: ReportUseCaseProtocol {
  private let reportService: ReportServiceProtocol

  init(reportService: ReportServiceProtocol) {
    self.reportService = reportService
  }

  func fetch(userID: String) async throws -> [Report] {
    try await reportService.fetch(uid: userID)
  }

  func post(type: ReportType, post: Post, user: User) async throws {
    guard let uid = user.id else { return }

    let report: Report = .init(
      id: post.id + uid,
      reportType: type,
      reporterID: uid,
      reporterName: user.name,
      postID: post.id,
      postUserID: post.userID,
      postUserName: post.name,
      postMessage: post.message,
      postImages: post.images,
      checked: false,
      answer: "未回答",
      createdAt: .init(),
      updatedAt: .init()
    )

    try await reportService.upload(report: report)
  }
}
