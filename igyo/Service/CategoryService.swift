import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol CategoryServiceProtocol {
  func fetch() async throws -> [Category]
}

final class CategoryService: CategoryServiceProtocol {
  private let firestore: Firestore = Firestore.firestore()
  private let collectionPath: String = "categories"

  func fetch() async throws -> [Category] {
    try await firestore.collection(collectionPath)
      .order(by: "index", descending: false)
      .limit(to: 10)
      .getDocuments()
      .documents
      .compactMap { try $0.data(as: Category.self) }
  }
}
