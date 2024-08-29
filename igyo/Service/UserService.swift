import FirebaseFirestore
import FirebaseFirestoreSwift

protocol UserServiceProcotol {
  func existsUser(id: String) async throws -> Bool
  func createNewUser(id: String, name: String, provider: String) async throws
  func fetchUser(id: String) async throws -> User
  func fetchNewUser() async throws -> [User]
  func updateUser(id: String, user: User) async throws
  func updateUser(id: String, imageURL: String) async throws
  func updateUser(id: String, icon: Icon, name: String) async throws
  func updateUser(id: String, icon: Icon) async throws
  func updateReactionCount(id: String) async throws
  func deleteReactionCount(id: String) async throws
  func updateUser(id: String, name: String) async throws
  func updateUser(id: String, type: UserType) async throws
  func updatePostCount(id: String, postCount: Int) async throws
  func update(id: String, name: String, imageUrl: String, description: String) async throws
  func delete(id: String) async throws
}

final class UserService: UserServiceProcotol {
  private let firestore: Firestore
  private let collectionPath: String = "users"

  init() {
    firestore = Firestore.firestore()
  }

  func existsUser(id: String) async throws -> Bool {
    try await firestore.collection(collectionPath)
      .document(id)
      .getDocument()
      .exists
  }

  func createNewUser(id: String, name: String, provider: String) async throws {
    try await firestore.collection(collectionPath)
      .document(id)
      .setData(
        [
          "id": id,
          "name": name,
          "type": UserType.normal.rawValue,
          "imageUrl": "",
          "description": "",
          "createdAt": FieldValue.serverTimestamp(),
          "updatedAt": FieldValue.serverTimestamp(),
          "postCount": 0,
          "reactionCount": 0,
          "provider": provider
        ]
      )
  }

  func fetchUser(id: String) async throws -> User {
    try await firestore
      .collection(collectionPath)
      .document(id)
      .getDocument()
      .data(as: User.self)
  }

  func updateUser(id: String, name: String) async throws {
    try await firestore.collection(collectionPath)
      .document(id)
      .updateData(
        [
          "name": name,
          "updatedAt": FieldValue.serverTimestamp()
        ]
      )
  }

  func updateUser(id: String, imageURL: String) async throws {
    try await firestore.collection(collectionPath)
      .document(id)
      .updateData(
        [
          "imageUrl": imageURL,
          "updatedAt": FieldValue.serverTimestamp()
        ]
      )
  }

  func updateUser(id: String, icon: Icon, name: String) async throws {
    try await firestore.collection(collectionPath)
      .document(id)
      .updateData(
        [
          "iconID": icon.id,
          "imageUrl": icon.imageURL,
          "name": name,
          "updatedAt": FieldValue.serverTimestamp()
        ]
      )
  }

  func updateUser(id: String, icon: Icon) async throws {
    try await firestore.collection(collectionPath)
      .document(id)
      .updateData(
        [
          "iconID": icon.id,
          "imageUrl": icon.imageURL,
          "updatedAt": FieldValue.serverTimestamp()
        ]
      )
  }

  func updateReactionCount(id: String) async throws {
    try await firestore.collection(collectionPath)
      .document(id)
      .updateData([
        "reactionCount": FieldValue.increment(Double(1.0)),
        "updatedAt": FieldValue.serverTimestamp()
      ])
  }

  func deleteReactionCount(id: String) async throws {
    try await firestore.collection(collectionPath)
      .document(id)
      .updateData([
        "reactionCount": FieldValue.increment(Double(-1.0)),
        "updatedAt": FieldValue.serverTimestamp()
      ])
  }

  func updateUser(id: String, type: UserType) async throws {
    try await firestore.collection(collectionPath)
      .document(id)
      .updateData(
        [
          "type": type.rawValue,
          "updatedAt": FieldValue.serverTimestamp()
        ]
      )
  }

  func updateUser(id: String, user: User) async throws {
    try await firestore.collection(collectionPath)
      .document(id)
      .updateData(
        [
          "name": user.name,
          "imageUrl": user.imageUrl,
          "description": user.description,
          "updatedAt": FieldValue.serverTimestamp()
        ]
      )
  }

  func updatePostCount(id: String, postCount: Int) async throws {
    try await firestore.collection(collectionPath)
      .document(id)
      .updateData(
        [
          "postCount": postCount,
          "updatedAt": FieldValue.serverTimestamp()
        ]
      )
  }

  func update(id: String, name: String, imageUrl: String, description: String) async throws {
    do {
      try await firestore.collection(collectionPath)
        .document(id)
        .updateData(
          [
            "name": name,
            "imageUrl": imageUrl,
            "description": description,
            "updatedAt": FieldValue.serverTimestamp()
          ]
        )
    } catch {
      throw error
    }
  }

  func fetchNewUser() async throws -> [User] {
    try await firestore.collection(collectionPath)
      .order(by: "createdAt", descending: true)
      .limit(to: 10)
      .getDocuments()
      .documents
      .compactMap { try $0.data(as: User.self) }
  }

  func delete(id: String) async throws {
    try await firestore.collection(collectionPath)
      .document(id)
      .updateData(
        [
          "name": "退会済みユーザー",
          "updatedAt": FieldValue.serverTimestamp(),
          "type": "ghost"
        ]
      )
  }
}
