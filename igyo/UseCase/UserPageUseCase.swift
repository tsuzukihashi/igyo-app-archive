import Foundation

protocol UserPageUseCaseProtocol {
  func fetch(id: String) async throws -> User
  @MainActor func block(id: String, completion: @escaping () -> Void)
  func fetchPosts(id: String) async throws -> [Post]
}

final class UserPageUseCase: UserPageUseCaseProtocol {
  private let userService: UserServiceProcotol
  private let postService: PostServiceProtocol

  init(
    userService: UserServiceProcotol,
    postService: PostServiceProtocol
  ) {
    self.userService = userService
    self.postService = postService
  }

  func fetch(id: String) async throws -> User {
    try await userService.fetchUser(id: id)
  }

  func fetchPosts(id: String) async throws -> [Post] {
    try await postService.fetch(type: .user(id: id))
  }

  func block(id: String, completion: @escaping () -> Void) {
    AppEnvironment.shared.blockIDs.append(id)
    completion()
  }
}
