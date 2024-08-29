import SwiftUI
import _AuthenticationServices_SwiftUI

struct SignUpView: View {
  @State var model = SignUpViewModel(
    useCase: SignUpUseCase(
      authService: AuthService(userService: UserService()),
      userService: UserService()
    )
  )

  var body: some View {
    ZStack {
      Color(.baseBackGround)
      VStack {
        LinearGradient(colors: [.clear, Color(.systemBackground)], startPoint: .bottom, endPoint: .top)
          .frame(maxHeight: .infinity)

        Image(.topIgyo)
          .resizable()
          .scaledToFit()
          .clipShape(RoundedRectangle(cornerRadius: 16))

        LinearGradient(colors: [.clear, Color(.systemBackground)], startPoint: .top, endPoint: .bottom)
          .frame(maxHeight: .infinity)
      }

      VStack(spacing: 24) {
        // MARK: Title
        VStack(spacing: 8) {
          Text("igyo")
            .font(.system(size: 82))
            .fontWeight(.heavy)
          Text("みんなで褒め合うSNS")
        }
        .padding(.top)

        Image(.topIgyo)
          .resizable()
          .scaledToFit()
          .opacity(0)

        // MARK: Methods
        VStack(spacing: 16, content: {
          SignInWithAppleButton(
            onRequest: model.onRequest,
            onCompletion: model.onCompletion
          )
          .signInWithAppleButtonStyle(.whiteOutline)
          .frame(height: 44)

          Button {
            Task {
              await model.requestGoogle()
            }
          } label: {
            ZStack {
              RoundedRectangle(cornerRadius: 4)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 44)

              HStack(alignment: .center) {
                Image(.googleLogo)
                  .resizable()
                  .scaledToFit()
                  .frame(width: 16)
                Text("Googleでサインイン")
                  .fontWeight(.medium)
                  .foregroundStyle(.black)
              }

              RoundedRectangle(cornerRadius: 4)
                .stroke(lineWidth: 0.5)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
            }
          }
          .tint(.white)

        })

        VStack(spacing: 4) {
          Text("サインインすることで、")
            .font(.system(size: 12))
          HStack(alignment: .bottom, spacing: 0) {
            Link("利用規約", destination: URL(string: "https://tsuzuki817.notion.site/f5cf56b582ff43e1b40ce55b56bb2d98")!)
              .font(.system(size: 14, weight: .bold))
            Text("と")
              .font(.system(size: 14))
            Link("プライバシーポリシー", destination: URL(string: "https://tsuzuki817.notion.site/326c43c324ec4ae187fb67d03bbca5fe")!)
              .font(.system(size: 14, weight: .bold))
          }
          Text("に同意したことになります。")
            .font(.system(size: 12))
        }
      }
      .padding(32)
    }
    .preferredColorScheme(.dark)
    .ignoresSafeArea()
  }
}

#Preview {
  SignUpView()
}
