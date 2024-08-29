import Foundation

protocol UserNameUseCaseProtocol {
  func validate(name: String) -> String
  func change(id: String, name: String) async throws
}

final class UserNameUseCase: UserNameUseCaseProtocol {
  private let userService: UserServiceProcotol

  init(userService: UserServiceProcotol) {
    self.userService = userService
  }

  func validate(name: String) -> String {
    if name.isEmpty {
      return "名前を入力してください"
    }

    if name.contains(where: { $0 == " " || $0 == "　"}) {
      return "名前にスペースを含めないでください"
    }

    if name.count > 30 {
      return "名前は30文字以下にしてください"
    }

    return ""
  }

  func change(id: String, name: String) async throws {
    try await userService.updateUser(id: id, name: name)
  }
}
