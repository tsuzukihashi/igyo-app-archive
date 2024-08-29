import Foundation
import FirebaseFirestoreSwift

struct User: FirestoreProtocol {
  @DocumentID
  var id: String?
  var type: UserType
  var name: String
  var iconID: String?
  var imageUrl: String
  var description: String
  var createdAt: Date
  var updatedAt: Date
  var postCount: Int
  var reactionCount: Int
}

extension User {
  static var stub0: User {
    .init(
      id: UUID().uuidString,
      type: UserType.normal,
      name: "たかし",
      iconID: "",
      imageUrl: "https://fromtheasia.com/wp-content/uploads/f0089f31bfaf24a02b70e20d92200e5a-scaled.jpg",
      description: "よろしくお願いします",
      createdAt: Date(),
      updatedAt: Date(),
      postCount: 10,
      reactionCount: 20
    )
  }
}
