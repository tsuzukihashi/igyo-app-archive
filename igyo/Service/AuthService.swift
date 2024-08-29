import FirebaseAuth
import CryptoKit
import AuthenticationServices
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol AuthServiceProtocol {
  var isLogin: Bool { get }
  func getCurrentUserID() -> String?
  func signOut() throws
  func delete() async throws

  // MARK: Apple SignIn Method
  func authenticate(credential: ASAuthorizationAppleIDCredential, nonce: String) async throws
  func signIn(idToken: String, accessToken: String) async throws
  func randomNonceString(length: Int) -> String
  func sha256(_ input: String) -> String
}

final class AuthService: AuthServiceProtocol, ObservableObject {
  private let userService: UserServiceProcotol

  let auth: Auth = Auth.auth()

  init(userService: UserServiceProcotol) {
    self.userService = userService
  }

  func delete() async throws {
    guard let uid = getCurrentUserID() else { return }
    try await userService.delete(id: uid)
    try await auth.currentUser?.delete()
    try auth.signOut()
  }

  var isLogin: Bool {
    auth.currentUser != nil
  }

  func getCurrentUserID() -> String? {
    auth.currentUser?.uid
  }

  func signOut() throws {
    do {
      try auth.signOut()
    } catch {
      throw AuthError.signOut
    }
  }

  func authenticate(credential: ASAuthorizationAppleIDCredential, nonce: String) async throws {
    guard let token = credential.identityToken, let tokenString = String(data: token, encoding: .utf8) else { return }
    let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)
    do {
      let result = try await auth.signIn(with: firebaseCredential)
      try await createUserIfNeeed(result, provider: "Apple")
    } catch {
      throw AuthError.failed
    }
  }

  // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
  func randomNonceString(length: Int) -> String {
    precondition(length > 0)
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length

    while remainingLength > 0 {
      let randoms: [UInt8] = (0 ..< 16).map { _ in
        var random: UInt8 = 0
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
        if errorCode != errSecSuccess {
          fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        return random
      }

      randoms.forEach { random in
        if remainingLength == 0 {
          return
        }

        if random < charset.count {
          result.append(charset[Int(random)])
          remainingLength -= 1
        }
      }
    }

    return result
  }

  func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
      return String(format: "%02x", $0)
    }.joined()

    return hashString
  }

  func signIn(idToken: String, accessToken: String) async throws {
    let credential = GoogleAuthProvider.credential(
      withIDToken: idToken,
      accessToken: accessToken
    )
    let result = try await auth.signIn(with: credential)
    try await createUserIfNeeed(result, provider: "Google")
  }

  private func createUserIfNeeed(_ result: AuthDataResult, provider: String) async throws {
    let userID = result.user.uid
    let isExists = try await userService.existsUser(id: userID)

    if isExists {
      try await userService.updateUser(id: userID, type: .normal)
    } else {
      try await userService.createNewUser(
        id: userID,
        name: result.user.displayName ?? String(result.user.uid.prefix(6)),
        provider: provider
      )
    }
  }
}
