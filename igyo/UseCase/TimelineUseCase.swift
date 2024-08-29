import Foundation

protocol TimelineUseCaseProtocol {
  func fetch() async throws -> [Post]
  func fetchNext(createdAt: Date) async throws -> [Post]
  func addAction(post: Post, user: User, action: ActionType) async throws -> Post
  func deleteAction(post: Post, user: User, action: ActionType) async throws -> Post
  func update(post: Post, postAction: PostActionType) async throws -> Post
}

final class TimelineUseCase: TimelineUseCaseProtocol {
  private let postService: PostServiceProtocol
  private let noticeService: NoticeServiceProtocol
  private let userService: UserServiceProcotol

  init(
    postService: PostServiceProtocol,
    noticeService: NoticeServiceProtocol,
    userService: UserServiceProcotol
  ) {
    self.postService = postService
    self.noticeService = noticeService
    self.userService = userService
  }

  func fetch() async throws -> [Post] {
    try await postService.fetch(type: .least)
  }

  func fetchNext(createdAt: Date) async throws -> [Post] {
    try await postService.fetch(createdAt: createdAt)
  }

  func addAction(post: Post, user: User, action: ActionType) async throws -> Post {
    var newValue = post
    HapticFeedbackManager.shared.play(.impact(.medium))

    switch action {
    case .unknown: break
    case .igyo:
      if let igyoCount = post.igyoCount {
        newValue.igyoCount = igyoCount + 1
      } else {
        newValue.igyoCount = 1
      }
    case .suteki:
      if let sutekiCount = post.sutekiCount {
        newValue.sutekiCount = sutekiCount + 1
      } else {
        newValue.sutekiCount = 1
      }
    case .kusa:
      if let kusaCount = post.kusaCount {
        newValue.kusaCount = kusaCount + 1
      } else {
        newValue.kusaCount = 1
      }
    case .welcome:
      if let welcomeCount = post.welcomeCount {
        newValue.welcomeCount = welcomeCount + 1
      } else {
        newValue.welcomeCount = 1
      }
    case .sugoi:
      if let sugoiCount = post.sugoiCount {
        newValue.sugoiCount = sugoiCount + 1
      } else {
        newValue.sugoiCount = 1
      }
    case .go:
      if let goCount = post.goCount {
        newValue.goCount = goCount + 1
      } else {
        newValue.goCount = 1
      }
    case .kansya:
      if let kansyaCount = post.kansyaCount {
        newValue.kansyaCount = kansyaCount + 1
      } else {
        newValue.kansyaCount = 1
      }
    case .saikyo:
      if let saikyoCount = post.saikyoCount {
        newValue.saikyoCount = saikyoCount + 1
      } else {
        newValue.saikyoCount = 1
      }
    case .appare:
      if let appareCount = post.appareCount {
        newValue.appareCount = appareCount + 1
      } else {
        newValue.appareCount = 1
      }
    case .tensai:
      if let tensaiCount = post.tensaiCount {
        newValue.tensaiCount = tensaiCount + 1
      } else {
        newValue.tensaiCount = 1
      }
    case .erai:
      if let eraiCount = post.eraiCount {
        newValue.eraiCount = eraiCount + 1
      } else {
        newValue.eraiCount = 1
      }
    case .iine:
      if let iineCount = post.iineCount {
        newValue.iineCount = iineCount + 1
      } else {
        newValue.iineCount = 1
      }
    case .otsukare:
      if let otsukareCount = post.otsukareCount {
        newValue.otsukareCount = otsukareCount + 1
      } else {
        newValue.otsukareCount = 1
      }
    case .sonkei:
      if let sonkeiCount = post.sonkeiCount {
        newValue.sonkeiCount = sonkeiCount + 1
      } else {
        newValue.sonkeiCount = 1
      }
    case .wakaru:
      if let wakaruCount = post.wakaruCount {
        newValue.wakaruCount = wakaruCount + 1
      } else {
        newValue.wakaruCount = 1
      }
    }
    let notice: Notice = .init(
      id: post.id + (user.id ?? "") + action.rawValue,
      type: post.postType,
      action: action,
      postID: post.id,
      postMessage: post.message,
      postUserName: post.name,
      postUserIcon: post.icon,
      postUserID: post.userID,
      isPremiumPost: post.isPremium,
      actionUserID: user.id ?? "",
      actionUserName: user.name,
      actionUserIcon: user.imageUrl,
      isPremiumAction: user.type == .suporter,
      createdAt: Date()
    )

    try await postService.addAction(post: newValue, action: action)
    try await noticeService.upload(notice: notice)
    try await userService.updateReactionCount(id: user.id ?? "")

    return newValue
  }

  func deleteAction(post: Post, user: User, action: ActionType) async throws -> Post {
    var newValue = post
    HapticFeedbackManager.shared.play(.impact(.medium))

    switch action {
    case .unknown: break
    case .igyo:
      if let igyoCount = post.igyoCount {
        newValue.igyoCount = igyoCount - 1
      } else {
        newValue.igyoCount = 0
      }
    case .suteki:
      if let sutekiCount = post.sutekiCount {
        newValue.sutekiCount = sutekiCount - 1
      } else {
        newValue.sutekiCount = 0
      }
    case .kusa:
      if let kusaCount = post.kusaCount {
        newValue.kusaCount = kusaCount - 1
      } else {
        newValue.kusaCount = 0
      }
    case .welcome:
      if let welcomeCount = post.welcomeCount {
        newValue.welcomeCount = welcomeCount - 1
      } else {
        newValue.welcomeCount = 0
      }
    case .sugoi:
      if let sugoiCount = post.sugoiCount {
        newValue.sugoiCount = sugoiCount - 1
      } else {
        newValue.sugoiCount = 0
      }
    case .go:
      if let goCount = post.goCount {
        newValue.goCount = goCount - 1
      } else {
        newValue.goCount = 0
      }
    case .kansya:
      if let kansyaCount = post.kansyaCount {
        newValue.kansyaCount = kansyaCount - 1
      } else {
        newValue.kansyaCount = 0
      }
    case .saikyo:
      if let saikyoCount = post.saikyoCount {
        newValue.saikyoCount = saikyoCount - 1
      } else {
        newValue.saikyoCount = 0
      }
    case .appare:
      if let appareCount = post.appareCount {
        newValue.appareCount = appareCount - 1
      } else {
        newValue.appareCount = 0
      }
    case .tensai:
      if let tensaiCount = post.tensaiCount {
        newValue.tensaiCount = tensaiCount - 1
      } else {
        newValue.tensaiCount = 0
      }
    case .erai:
      if let eraiCount = post.eraiCount {
        newValue.eraiCount = eraiCount - 1
      } else {
        newValue.eraiCount = 0
      }
    case .iine:
      if let iineCount = post.iineCount {
        newValue.iineCount = iineCount - 1
      } else {
        newValue.iineCount = 0
      }
    case .otsukare:
      if let otsukareCount = post.otsukareCount {
        newValue.otsukareCount = otsukareCount - 1
      } else {
        newValue.otsukareCount = 0
      }
    case .sonkei:
      if let sonkeiCount = post.sonkeiCount {
        newValue.sonkeiCount = sonkeiCount - 1
      } else {
        newValue.sonkeiCount = 0
      }
    case .wakaru:
      if let wakaruCount = post.wakaruCount {
        newValue.wakaruCount = wakaruCount - 1
      } else {
        newValue.wakaruCount = 0
      }
    }
    let id = post.id + (user.id ?? "") + action.rawValue

    try await noticeService.delete(id: id)
    try await postService.deleteAction(post: newValue, action: action)
    try await userService.deleteReactionCount(id: user.id ?? "")

    return newValue
  }

  func update(post: Post, postAction: PostActionType) async throws -> Post {
    var newValue: Post = post
    switch postAction {

    case .delete:
      try await postService.delete(postID: post.id)
    case .report:
      newValue.reportCount += 1
      try await postService.updateReportCount(post: post)
    case .hidden, .unknown:
      break
    }
    return newValue
  }
}
