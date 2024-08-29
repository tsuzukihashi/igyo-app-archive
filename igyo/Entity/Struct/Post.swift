import Foundation
import FirebaseFirestoreSwift

struct Post: FirestoreProtocol {
  var id: String
  var userID: String
  var name: String
  var icon: String
  var iconID: String
  var message: String
  var images: [String]
  var reportCount: Int
  var createdAt: Date
  var updatedAt: Date
  var postType: PostType
  var categoryIndex: Int?
  var isPremium: Bool?

  /**
   MARK: ActionTypeを追加するには
   Countをオプショナルで追加
   PostCellViewとPostDetailViewに修正を入れる
   */
  var igyoCount: Int?
  var sutekiCount: Int?
  var kusaCount: Int?
  var welcomeCount: Int?
  var sugoiCount: Int?
  var goCount: Int?
  var kansyaCount: Int?
  var saikyoCount: Int?
  var appareCount: Int?
  var tensaiCount: Int?
  var eraiCount: Int?
  var iineCount: Int?
  var otsukareCount: Int?
  var sonkeiCount: Int?
  var wakaruCount: Int?

  init(
    id: String,
    userID: String,
    name: String,
    icon: String,
    iconID: String,
    message: String,
    images: [String],
    reportCount: Int,
    createdAt: Date,
    updatedAt: Date,
    postType: PostType,
    igyoCount: Int? = nil,
    sutekiCount: Int? = nil,
    kusaCount: Int? = nil,
    welcomeCount: Int? = nil,
    sugoiCount: Int? = nil,
    goCount: Int? = nil,
    kansyaCount: Int? = nil,
    saikyoCount: Int? = nil,
    appareCount: Int? = nil,
    tensaiCount: Int? = nil,
    eraiCount: Int? = nil,
    iineCount: Int? = nil,
    otsukareCount: Int? = nil,
    sonkeiCount: Int? = nil,
    wakaruCount: Int? = nil,
    categoryIndex: Int?,
    isPremium: Bool?
  ) {
    self.id = id
    self.userID = userID
    self.name = name
    self.icon = icon
    self.iconID = iconID
    self.message = message
    self.images = images
    self.reportCount = reportCount
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.postType = postType
    self.igyoCount = igyoCount
    self.sutekiCount = sutekiCount
    self.kusaCount = kusaCount
    self.welcomeCount = welcomeCount
    self.sugoiCount = sugoiCount
    self.goCount = goCount
    self.kansyaCount = kansyaCount
    self.saikyoCount = saikyoCount
    self.appareCount = appareCount
    self.tensaiCount = tensaiCount
    self.eraiCount = eraiCount
    self.iineCount = iineCount
    self.otsukareCount = otsukareCount
    self.sonkeiCount = sonkeiCount
    self.wakaruCount = wakaruCount
    self.categoryIndex = categoryIndex
    self.isPremium = isPremium
  }

  init(notice: Notice) {
    id = notice.postID
    userID = notice.postUserID
    name = notice.postUserName
    icon = notice.postUserIcon
    iconID = ""
    message = notice.postUserName
    images = []
    reportCount = 0
    createdAt = Date()
    updatedAt = Date()
    postType = notice.type
    categoryIndex = notice.categoryIndex
  }
}

extension Post {
  static var stub: Post {
    .init(
      id: UUID().uuidString,
      userID: UUID().uuidString,
      name: "たかし",
      icon: "https://fromtheasia.com/wp-content/uploads/f0089f31bfaf24a02b70e20d92200e5a-scaled.jpg",
      iconID: "",
      message: "今日はゴミ捨てをした\n https://google.com\n1\n2\n3\n4\n5",
      images: ["https://pbs.twimg.com/media/GAMRuypbAAAGfJL?format=jpg&name=small"],
      reportCount: 0,
      createdAt: Date(),
      updatedAt: Date(),
      postType: .first, 
      categoryIndex: 123,
      isPremium: false
    )
  }
}
