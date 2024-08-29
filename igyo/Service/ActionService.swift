import Foundation

protocol ActionServiceProtocol {

}

final class ActionService: ActionServiceProtocol {
  public static let shared: ActionService = .init()

  private init() {}
}
