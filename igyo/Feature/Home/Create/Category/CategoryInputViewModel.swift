import Foundation

@Observable
class CategoryInputViewModel {
  var query: String = ""
  var displayCategories: [Category] = []

  private let useCase: any CategoryUseCaseProtocol

  init(useCase: any CategoryUseCaseProtocol) {
    self.useCase = useCase
  }

  func onAppear(categories: [Category]) async {
    displayCategories = categories
  }

  func filterCategory(categories: [Category]) {
    if query.isEmpty {
      displayCategories = categories
    } else {
      if query == "勉強", let study = categories.first(where: { $0.index == 1 }) {
        displayCategories = [study]
      } else {
        displayCategories = categories.filter { $0.title.contains(query) }
      }
    }
  }
}
