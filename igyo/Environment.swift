import Foundation
import SwiftUI

@MainActor
class AppEnvironment: ObservableObject {
  @Published var paths: [IgyoPath] = []
  @AppStorage("launchCount") var launchCount = 0
  @AppStorage("showTutorial") var showTutorial: Bool = true
  @AppStorage("actionIDs")
  private var actionIDs: [String] = []

  @AppStorage("blockIDs") var blockIDs: [String] = []
  @AppStorage("hiddenPostIDs") var hiddenPostIDs: [String] = []
  @AppStorage("isPremiumUser") var isPremiumUser: Bool = false
  
  @Published var isLogin: Bool?
  @Published var user: User?

  @Published var showForceUpdate: Bool = false
  @Published var storeURL: URL?

  // MARK: 自分がリアクションしたIDリスト
  @Published var igyoIDs: [String] = []
  @Published var sutekiIDs: [String] = []
  @Published var kusaIDs: [String] = []

  @Published var alertType: AlertType?
  @Published var nameChangeAnimation: Bool = false

  // MARK: 画像表示するやつら
  @Published var showImageURL: String = ""
  @Published var showImage: Image = Image("force-update")
  @Published var showViewer: Bool = false
  @Published var showViewerURL: Bool = false
  @Published var showMenu: Bool = false
  @Published var showPurchaseView: Bool = false

  public static let shared: AppEnvironment = .init()

  private init() {}

  func isReaction(postID: String, type: ActionType) -> Bool {
    let id = postID + type.rawValue
    return actionIDs.contains(id)
  }

  func addReaction(postID: String, type: ActionType) {
    let id = postID + type.rawValue
    if actionIDs.contains(id) {
      actionIDs.removeAll(where: { $0 == id })
    }

    actionIDs.insert(id, at: 0)

    if actionIDs.count > 200 {
      actionIDs.removeLast()
    }
  }

  func deleteReaction(postID: String, type: ActionType) {
    let id = postID + type.rawValue
    actionIDs.removeAll(where: { $0 == id })
  }
}
