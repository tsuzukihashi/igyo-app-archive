import Foundation

class TutorialViewModel: ObservableObject {
  @Published var contents: TutorialPageContent = .page1

}

extension TutorialViewModel {
  enum TutorialPageContent {
    case page1
    case page2
    case page3
    case page4
  }
}
