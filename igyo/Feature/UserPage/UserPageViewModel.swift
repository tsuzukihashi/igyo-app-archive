import Foundation

@Observable
final class UserPageViewModel {
  var user: User?
  var posts: [Post] = []
  var selectedPost: Post?
  private let useCase: UserPageUseCaseProtocol
  private let timelineUseCase: TimelineUseCaseProtocol

  init(useCase: UserPageUseCaseProtocol, timelineUseCase: TimelineUseCaseProtocol) {
    self.useCase = useCase
    self.timelineUseCase = timelineUseCase
  }

  func pullToRefresh(id: String) async {
    await fetch(id: id)
  }

  func onAppear(id: String) async {
    guard posts.isEmpty else { return }
    await fetch(id: id)
  }

  private func fetch(id: String) async {
    do {
      user = try await useCase.fetch(id: id)
      posts = try await useCase.fetchPosts(id: id)
    } catch {
      print(error.localizedDescription)
    }
  }

  @MainActor
  func didTapBlock(id: String, completion: @escaping () -> Void) {
    useCase.block(id: id, completion: completion)
  }

  func showBlockButton(userID: String, blockIDs: [String], myID: String?) -> Bool {
    !blockIDs.contains(where: { $0 == userID }) && myID != userID
  }

  func didTapAction(post: Post, user: User?, type: ActionType) async {
    guard let user else { return }
    do {
      let result = try await timelineUseCase.addAction(post: post, user: user, action: type)
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
      let result = try await timelineUseCase.deleteAction(post: post, user: user, action: type)
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
      let result = try await timelineUseCase.update(post: post, postAction: type)
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
