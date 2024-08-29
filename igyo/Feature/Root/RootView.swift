import SwiftUI

struct RootView: View {
  @EnvironmentObject var environemnt: AppEnvironment
  @State var model = RootViewModel(
    authService: AuthService(userService: UserService()),
    userService: UserService(),
    purchaseUseCase: PurchaseUseCase(userService: UserService(), purchaseService: PurchaseService()
                                    )
  )

  var body: some View {
    switch environemnt.isLogin {
    case true:
      if let user = environemnt.user {
        if user.iconID == nil {
          SetupView()
            .background(Color(.baseBackGround))
        } else {
          HomeView()
            .background(Color(.baseBackGround))
            .onAppear() {
              model.onAppear(uid: user.id)
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
              Task {
                await model.willEnterForegroundNotification(uid: user.id)
              }
            }
            .sheet(isPresented: $environemnt.showPurchaseView) {
              PurchaseView()
            }
        }
      } else {
        LoopLottieView(name: "loading")
          .frame(height: 300)
          .task {
            environemnt.user = await model.fetchMySelfIfNeeded()
          }
      }
    case false:
      SignUpView()
        .fullScreenCover(isPresented: $environemnt.showTutorial) {
          TutorialView()
        }
        .fullScreenCover(isPresented: $environemnt.showForceUpdate, content: {
          ForceUpdateView()
        })
        .background(Color(.baseBackGround))
    default:
      LoopLottieView(name: "loading")
        .frame(height: 300)
        .task {
          environemnt.isLogin = model.isLoginUser()
          environemnt.user = await model.fetchMySelfIfNeeded()
        }
    }
  }
}

#Preview {
  RootView()
}
