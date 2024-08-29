import Foundation

struct Report: FirestoreProtocol {
  var id: String
  var reportType: ReportType
  var reporterID: String
  var reporterName: String
  var postID: String
  var postUserID: String
  var postUserName: String
  var postMessage: String
  var postImages: [String]
  var checked: Bool
  var answer: String
  var createdAt: Date
  var updatedAt: Date
}
