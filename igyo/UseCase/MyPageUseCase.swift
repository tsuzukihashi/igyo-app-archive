import Foundation

protocol MyPageUseCaseProtocol {
  func fetch(userID: String) async throws -> [Post]
  func fetchSelf(userID: String) async throws -> User
  func delete(postID: String) async throws
}

final class MyPageUseCase: MyPageUseCaseProtocol {
  private let postService: PostServiceProtocol
  private let userService: UserServiceProcotol

  init(postService: PostServiceProtocol, userService: UserServiceProcotol) {
    self.postService = postService
    self.userService = userService
  }

  func fetch(userID: String) async throws -> [Post] {
    try await postService.fetch(type: .user(id: userID))
  }

  func fetchSelf(userID: String) async throws -> User {
    try await userService.fetchUser(id: userID)
  }

  func delete(postID: String) async throws {
    try await postService.delete(postID: postID)
  }
}
