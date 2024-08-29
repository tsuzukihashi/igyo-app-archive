import Foundation

protocol CreateUseCaseProtocol {
  func create(user: User, message: String, imageData: [Data], category: Category?) async throws
}

final class CreateUseCase: CreateUseCaseProtocol {
  private let userService: UserServiceProcotol
  private let postService: PostServiceProtocol
  private let imageService: ImageServiceProtocol

  init(
    userService: UserServiceProcotol,
    postService: PostServiceProtocol,
    imageService: ImageServiceProtocol
  ) {
    self.userService = userService
    self.postService = postService
    self.imageService = imageService
  }

  func create(user: User, message: String, imageData: [Data], category: Category?) async throws {
    guard let uid = user.id else { return }
    let postID = UUID().uuidString
    // MARK: 画像のアップロード処理

    let urls = try await imageData.parallelMap(
      parallelism: imageData.count
    ) { [weak self] data in
      let index = imageData.firstIndex(of: data) ?? 0
      return try await self?.imageService.upload(
        data: data,
        type: .post(id: postID + "_" + String(index), uid: uid)
      )
    }

    // MARK: 投稿処理
    let post: Post = .init(
      id: postID,
      userID: uid,
      name: user.name,
      icon: user.imageUrl,
      iconID: user.iconID ?? "",
      message: message,
      images: urls.compactMap { $0?.absoluteString },
      reportCount: 0,
      createdAt: Date(),
      updatedAt: Date(),
      postType: PostType.generate(
        postCount: user.postCount,
        reactionCount: user.reactionCount
      ),
      // TODO: 2月になったらnilにする
      igyoCount: 0,
      sutekiCount: 0,
      kusaCount: 0,
      welcomeCount: 0, 
      categoryIndex: category?.index, 
      isPremium: user.type == .suporter
    )

    try await postService.upload(post: post)
    try await userService.updatePostCount(id: uid, postCount: user.postCount + 1)
  }
}
