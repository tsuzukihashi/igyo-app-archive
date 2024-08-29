import Foundation

@Observable
class DiscoverCategoryViewModel {
  var posts: [Post]
  var selectedPost: Post?
  private let useCase: any TimelineUseCaseProtocol
  private let discoverUseCase: any DiscoverUseCaseProtocol

  init(
    useCase: any TimelineUseCaseProtocol,
    discoverUseCase: any DiscoverUseCaseProtocol
  ) {
    self.posts = []
    self.useCase = useCase
    self.discoverUseCase = discoverUseCase
  }

  func onAppear(category: Category) async {
    do {
      posts = try await discoverUseCase.fetchPosts(category: category)
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
