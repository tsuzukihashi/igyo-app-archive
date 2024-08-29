import Foundation

protocol DiscoverUseCaseProtocol {
  func fetchDisplayUser() async throws -> [User]
  func fetchPosts(category: Category) async throws -> [Post]
}

final class DiscoverUseCase: DiscoverUseCaseProtocol {
  private let userService: any UserServiceProcotol
  private let postService: any PostServiceProtocol

  init(
    userService: any UserServiceProcotol,
    postService: any PostServiceProtocol
  ) {
    self.userService = userService
    self.postService = postService
  }

  func fetchDisplayUser() async throws -> [User] {
    try await userService.fetchNewUser()
      .filter { $0.type != .ghost }
  }

  func fetchPosts(category: Category) async throws -> [Post] {
    try await postService.fetch(type: .category(category: category))
  }
}
