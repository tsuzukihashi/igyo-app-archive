import Foundation

protocol CategoryUseCaseProtocol {
  func fetch() async throws -> [Category]
}

final class CategoryUseCase: CategoryUseCaseProtocol {
  private let service: any CategoryServiceProtocol

  init(service: any CategoryServiceProtocol) {
    self.service = service
  }

  func fetch() async throws -> [Category] {
    try await service.fetch()
  }
}
