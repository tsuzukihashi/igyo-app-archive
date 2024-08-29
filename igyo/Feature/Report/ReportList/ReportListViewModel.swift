import Foundation

@Observable
final class ReportListViewModel {
  var reports: [Report] = []

  private let useCase: ReportUseCaseProtocol

  init(useCase: ReportUseCaseProtocol) {
    self.useCase = useCase
  }

  func onAppear(userID: String?) async {
    guard let userID else { return }
    do {
      reports = try await useCase.fetch(userID: userID)
    } catch {
      print(error.localizedDescription)
    }
  }
}
