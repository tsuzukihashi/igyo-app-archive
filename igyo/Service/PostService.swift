import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol PostServiceProtocol {
  func fetch(type: PostService.FetchType) async throws -> [Post]
  func fetch(createdAt: Date) async throws -> [Post]
  func upload(post: Post) async throws
  func addAction(post: Post, action: ActionType) async throws
  func deleteAction(post: Post, action: ActionType) async throws
  func updateReportCount(post: Post) async throws
  func delete(postID: String) async throws
}

final class PostService: PostServiceProtocol {
  enum FetchType {
    case user(id: String)
    case least
    case category(category: Category)
  }

  private let firestore: Firestore = Firestore.firestore()
  private let collectionPath: String = "posts"

  func fetch(type: FetchType) async throws -> [Post] {
    let blockIds = await AppEnvironment.shared.blockIDs
    let hiddenPostIDs = await AppEnvironment.shared.hiddenPostIDs

    switch type {
    case .user(let id):
      return try await firestore.collection(collectionPath)
        .order(by: "createdAt", descending: true)
        .whereField("userID", isEqualTo: id)
        .limit(to: 100)
        .getDocuments()
        .documents
        .compactMap { try $0.data(as: Post.self) }
        .filter { !blockIds.contains($0.userID) }
        .filter { !hiddenPostIDs.contains($0.id) }

    case .least:
      return try await firestore.collection(collectionPath)
        .order(by: "createdAt", descending: true)
        .limit(to: 100)
        .getDocuments()
        .documents
        .compactMap { try $0.data(as: Post.self) }
        .filter { !blockIds.contains($0.userID) }
        .filter { !hiddenPostIDs.contains($0.id) }
    case .category(let category):
      return try await firestore.collection(collectionPath)
        .order(by: "createdAt", descending: true)
        .whereField("categoryIndex", isEqualTo: category.index)
        .limit(to: 100)
        .getDocuments()
        .documents
        .compactMap { try $0.data(as: Post.self) }
        .filter { !blockIds.contains($0.userID) }
        .filter { !hiddenPostIDs.contains($0.id) }
    }
  }

  func fetch(createdAt: Date) async throws -> [Post] {
    let blockIds = await AppEnvironment.shared.blockIDs
    let hiddenPostIDs = await AppEnvironment.shared.hiddenPostIDs
    return try await firestore.collection(collectionPath)
      .order(by: "createdAt", descending: true)
      .start(after: [createdAt.addingTimeInterval(-1)])
      .limit(to: 100)
      .getDocuments()
      .documents
      .compactMap { try $0.data(as: Post.self) }
      .filter { !blockIds.contains($0.userID) }
      .filter { !hiddenPostIDs.contains($0.id) }
  }

  func upload(post: Post) async throws {
    try await firestore.collection(collectionPath)
      .document(post.id)
      .setData([
        "id": post.id,
        "userID": post.userID,
        "name": post.name,
        "icon": post.icon,
        "iconID": post.iconID,
        "message": post.message,
        "images": post.images,
        "reportCount": 0,
        "categoryIndex": post.categoryIndex ?? NSNull(),
        "igyoCount": 0,
        "sutekiCount": 0,
        "kusaCount": 0,
        "welcomeCount": 0,
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
        "postType": post.postType.rawValue,
        "isPremium": post.isPremium ?? NSNull()
      ])
  }

  func addAction(post: Post, action: ActionType) async throws {
    switch action {
    case .unknown:
      break
    default:
      try await firestore.collection(collectionPath)
        .document(post.id)
        .updateData([
          action.rawValue + "Count": FieldValue.increment(Double(1.0)),
          "updatedAt": FieldValue.serverTimestamp()
        ])
    }
  }

  func deleteAction(post: Post, action: ActionType) async throws {
    switch action {
    case .unknown:
      break
    default:
      try await firestore.collection(collectionPath)
        .document(post.id)
        .updateData([
          action.rawValue + "Count": FieldValue.increment(Double(-1.0)),
          "updatedAt": FieldValue.serverTimestamp()
        ])
    }
  }

  func delete(postID: String) async throws {
    try await firestore.collection(collectionPath)
      .document(postID)
      .delete()
  }

  func updateReportCount(post: Post) async throws {
    try await firestore.collection(collectionPath)
      .document(post.id)
      .updateData([
        "reportCount": FieldValue.increment(Double(1.0)),
        "updatedAt": FieldValue.serverTimestamp()
      ])
  }
}
