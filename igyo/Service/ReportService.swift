import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol ReportServiceProtocol {
  func upload(report: Report) async throws
  func fetch(uid: String) async throws -> [Report]
}

final class ReportService: ReportServiceProtocol {
  private let firestore: Firestore = Firestore.firestore()
  private let collectionPath: String = "reports"

  func upload(report: Report) async throws {
    try await firestore.collection(collectionPath)
      .document(report.id)
      .setData([
        "id": report.id,
        "reportType": report.reportType.rawValue,
        "reporterID": report.reporterID,
        "reporterName": report.reporterName,
        "postID": report.postID,
        "postUserID": report.postUserID,
        "postUserName": report.postUserName,
        "postMessage": report.postMessage,
        "postImages": report.postImages,
        "checked": report.checked,
        "answer": report.answer,
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp()
      ])
  }

  func fetch(uid: String) async throws -> [Report] {
    try await firestore.collection(collectionPath)
      .order(by: "createdAt", descending: true)
      .whereField("reporterID", isEqualTo: uid)
      .limit(to: 100)
      .getDocuments()
      .documents
      .compactMap { try $0.data(as: Report.self) }
  }
}
