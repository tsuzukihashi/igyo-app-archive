import Foundation

enum IgyoPath: Hashable {
  case settings
  case discover
  case notice
  case mypage
  case userProfile(userID: String)
  case detail(post: Post)
  case report(post: Post)
  case nameEditor
  case iconEditor
  case blockList
  case hiddenList
  case reportList
  case actionsList(userID: String)
  case categoryDiscover(category: Category)
  case premiumIconEditor
}
