import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol NoticeServiceProtocol {
  func upload(notice: Notice) async throws
  func delete(id: String) async throws
  func fetch(postID: String) async throws -> [Notice]
  func fetch(postUserID: String) async throws -> [Notice]
  func fetch(actionUserID: String) async throws -> [Notice]
  func fetch(actionUserID: String, createdAt: Date) async throws -> [Notice]
}

final class NoticeService: NoticeServiceProtocol {
  private let firestore: Firestore
  private let collectionPath: String = "notices"

  init() {
    firestore = Firestore.firestore()
  }

  func upload(notice: Notice) async throws {
    try await firestore.collection(collectionPath)
      .document(notice.id)
      .setData([
        "id": notice.id,
        "type": notice.type.rawValue,
        "action": notice.action.rawValue,
        "postID": notice.postID,
        "postMessage": notice.postMessage,
        "postUserName": notice.postUserName,
        "postUserIcon": notice.postUserIcon,
        "postUserID": notice.postUserID,
        "isPremiumPost": notice.isPremiumPost ?? NSNull(),
        "actionUserID": notice.actionUserID,
        "actionUserName": notice.actionUserName,
        "actionUserIcon": notice.actionUserIcon,
        "isPremiumAction": notice.isPremiumAction ?? NSNull(),
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp()
      ])
  }

  func delete(id: String) async throws {
    try await firestore.collection(collectionPath)
      .document(id)
      .delete()
  }

  func fetch(postID: String) async throws -> [Notice] {
    try await firestore.collection(collectionPath)
      .order(by: "createdAt", descending: true)
      .whereField("postID", isEqualTo: postID)
      .limit(to: 100)
      .getDocuments()
      .documents
      .compactMap { try $0.data(as: Notice.self) }
  }

  func fetch(postUserID: String) async throws -> [Notice] {
    try await firestore.collection(collectionPath)
      .order(by: "createdAt", descending: true)
      .whereField("postUserID", isEqualTo: postUserID)
      .limit(to: 100)
      .getDocuments()
      .documents
      .compactMap { try $0.data(as: Notice.self) }
  }  

  func fetch(actionUserID: String) async throws -> [Notice] {
    try await firestore.collection(collectionPath)
      .order(by: "createdAt", descending: true)
      .whereField("actionUserID", isEqualTo: actionUserID)
      .limit(to: 100)
      .getDocuments()
      .documents
      .compactMap { try $0.data(as: Notice.self) }
  }

  func fetch(actionUserID: String, createdAt: Date) async throws -> [Notice] {
    try await firestore.collection(collectionPath)
      .order(by: "createdAt", descending: true)
      .start(after: [createdAt.addingTimeInterval(-1)])
      .whereField("actionUserID", isEqualTo: actionUserID)
      .limit(to: 100)
      .getDocuments()
      .documents
      .compactMap { try $0.data(as: Notice.self) }
  }
}
