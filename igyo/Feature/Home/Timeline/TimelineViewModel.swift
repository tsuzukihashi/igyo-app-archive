import Foundation

@Observable
class TimelineViewModel {
  private let useCase: any TimelineUseCaseProtocol
  private let categoryUseCase: any CategoryUseCaseProtocol
  var posts: [Post] = []
  var displayPosts: [Post] = []
  var selectedPost: Post?
  var showPostScreen: Bool = false

  init(
    useCase: any TimelineUseCaseProtocol,
    categoryUseCase: any CategoryUseCaseProtocol
  ) {
    self.useCase = useCase
    self.categoryUseCase = categoryUseCase
  }

  func pullToRefresh() async {
    HapticFeedbackManager.shared.play(.impact(.medium))
    await fetch()
  }

  func fetchCategory() async -> [CachedCategory] {
    do {
      return try await categoryUseCase.fetch().compactMap { $0.convert() }
    } catch {
      print(error.localizedDescription)
      return []
    }
  }

  func onAppear() async {
    guard posts.isEmpty else { return }
    await fetch()
  }

  private func fetch() async {
    do {
      posts = try await useCase.fetch()
    } catch {
      print(error.localizedDescription)
    }
  }

  func nextFetchIfNeeded(post: Post) async {
    guard posts.last?.id == post.id else { return }
    do {
      posts += try await useCase.fetchNext(createdAt: post.createdAt)
    } catch {
      print(error.localizedDescription)
    }
  }

  func didTapAction(post: Post, user: User?, type: ActionType) async {
    guard let user else { return }
    do {
      let result = try await useCase.addAction(post: post, user: user, action: type)
      if let index = posts.firstIndex(where: { $0 == post }) {
        posts[index] = result
      }

      Task { @MainActor in
        AppEnvironment.shared.addReaction(postID: post.id, type: type)
      }
    } catch {
      print(error.localizedDescription)
    }
  }

  func didTapUnAction(post: Post, user: User?, type: ActionType) async {
    guard let user else { return }
    do {
      let result = try await useCase.deleteAction(post: post, user: user, action: type)
      if let index = posts.firstIndex(where: { $0 == post }) {
        posts[index] = result
      }

      Task { @MainActor in
        AppEnvironment.shared.deleteReaction(postID: post.id, type: type)
      }
    } catch {
      print(error.localizedDescription)
    }
  }

  func didTapPostAction(post: Post, type: PostActionType) async {
    do {
      let result = try await useCase.update(post: post, postAction: type)
      switch type {
      case .unknown: break
      case .delete:
        posts.removeAll(where: { $0 == post })
      case .report:
        if let index = posts.firstIndex(where: { $0 == post }) {
          posts[index] = result
        }
      case .hidden:
        posts.removeAll(where: { $0 == post })
        Task { @MainActor in
          AppEnvironment.shared.hiddenPostIDs.append(post.id)
        }
      }

    } catch {
      print(error.localizedDescription)
    }
  }
}
