import Foundation
import FirebaseAuth
import AuthenticationServices

@Observable
class SignUpViewModel {
  private let useCase: SignUpUseCaseProtocol

  init(useCase: SignUpUseCaseProtocol) {
    self.useCase = useCase
  }

  func onRequest(request: ASAuthorizationAppleIDRequest) {
    useCase.onRequest(request: request)
  }

  func onCompletion(result: Result<ASAuthorization, any Error>) {
    useCase.onCompletion(result: result)
  }

  func requestGoogle() async {
    guard let presentingViewController = await (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
    do {
      try await useCase.signInWithGoogle(parent: presentingViewController)
    } catch {
      print(error.localizedDescription)
    }
  }
}
