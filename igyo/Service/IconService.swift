import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol IconServiceProtocol {
  func fetch() async throws -> [Icon]
}

final class IconService: IconServiceProtocol {
  private let firestore: Firestore = Firestore.firestore()
  private let collectionPath: String = "icons"

  func fetch() async throws -> [Icon] {
    let d = try await firestore.collection(collectionPath)
      .order(by: "createdAt", descending: false)
      .limit(to: 100)
      .getDocuments()
      .documents
    return try d.compactMap { try $0.data(as: Icon.self)  }
  }
}
