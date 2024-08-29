import AuthenticationServices
import FirebaseCore
import Foundation
import GoogleSignIn

protocol SignUpUseCaseProtocol {
  func onRequest(request: ASAuthorizationAppleIDRequest)
  func onCompletion(result: Result<ASAuthorization, any Error>)
  func signInWithGoogle(parent: UIViewController) async throws
}

final class SignUpUseCase: SignUpUseCaseProtocol {
  private var nonce = ""

  private let authService: AuthServiceProtocol
  private let userService: UserServiceProcotol

  init(
    authService: AuthServiceProtocol,
    userService: UserServiceProcotol
  ) {
    self.authService = authService
    self.userService = userService
  }

  func onRequest(request: ASAuthorizationAppleIDRequest) {
    nonce = authService.randomNonceString(length: 32)
    request.requestedScopes = [.email, .fullName]
    request.nonce = authService.sha256(nonce)
  }

  func onCompletion(result: Result<ASAuthorization, any Error>) {
    switch result {
    case .success(let auth):
      guard let credential = auth.credential as? ASAuthorizationAppleIDCredential else { return }
      Task {
        try await authService.authenticate(credential: credential, nonce: nonce)
        await updateLoginStatus()

      }
    case .failure(let error):
      print(error.localizedDescription)
    }
  }

  @MainActor
  func updateLoginStatus() {
    AppEnvironment.shared.isLogin = true
  }

  func signInWithGoogle(parent: UIViewController) async throws {
    guard let clientID = FirebaseApp.app()?.options.clientID else { return }
    GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)

    let result = try await showGoogleSignInView(parent: parent)

    guard let idToken = result.user.idToken?.tokenString else { return }

    try await authService.signIn(
      idToken: idToken, 
      accessToken: result.user.accessToken.tokenString
    )
    await updateLoginStatus()
  }

  @MainActor
  private func showGoogleSignInView(parent: UIViewController) async throws ->  GIDSignInResult {
    try await GIDSignIn.sharedInstance.signIn(withPresenting: parent)
  }
}
