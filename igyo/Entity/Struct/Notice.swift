import Foundation

struct Notice: FirestoreProtocol {
  var id: String
  var type: PostType
  var action: ActionType
  var postID: String
  var postMessage: String
  var postUserName: String
  var postUserIcon: String
  var postUserID: String
  var isPremiumPost: Bool?
  var actionUserID: String
  var actionUserName: String
  var actionUserIcon: String
  var isPremiumAction: Bool?
  var createdAt: Date
  var categoryIndex: Int?
}

extension Notice {
  static var stub: Notice {
    .init(
      id: UUID().uuidString,
      type: .bronze,
      action: .igyo,
      postID: "postID",
      postMessage: "今日も一日頑張ったぞい",
      postUserName: "太郎",
      postUserIcon: "https://creatorspace.imgix.net/users/clea2k77300bju30yss28yain/NPKd5DYTTq10mt9y-FGqcEZhM_400x400.jpg?w=300&h=300",
      postUserID: "taro",
      actionUserID: "yamada",
      actionUserName: "山田",
      actionUserIcon: "https://play-lh.googleusercontent.com/cicAsfh58tn8x6m2Ya2TdI4Ei5QJ0jDqEx__z7uI-HzH5xSIbDqgZA1Rmt9DSS-m-A=w600-h300-pc0xffffff-pd",
      createdAt: .init(timeIntervalSince1970: 53987598344),
      categoryIndex: 123
    )
  }
}
