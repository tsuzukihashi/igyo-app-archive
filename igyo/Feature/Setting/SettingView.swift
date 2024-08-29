import SwiftUI

struct SettingView: View {
  @EnvironmentObject var environment: AppEnvironment
  @State var model: SettingViewModel = .init(
    useCase: SettingUseCase(authService: AuthService(userService: UserService()))
  )

  var body: some View {
    List {
      Section("アカウント") {
        NavigationLink(value: IgyoPath.nameEditor) {
          Text("ユーザ名を変更")
        }

        NavigationLink(value: IgyoPath.iconEditor) {
          Text("アイコンを変更")
        }
        
        NavigationLink(value: IgyoPath.blockList) {
          Text("ブロックしたユーザーリスト")
        }

        NavigationLink(value: IgyoPath.hiddenList) {
          Text("非表示にした投稿リスト")
        }

        NavigationLink(value: IgyoPath.reportList) {
          Text("報告した違反申告リスト")
        }
      }
      Section {
        NavigationLink(value: IgyoPath.premiumIconEditor) {
          VStack(alignment: .leading) {
            Text("好きな画像をアイコンに設定する")
            Text("igyoが用意したアイコン以外に自由にアイコンを設定することができるようになります。")
              .font(.caption)
          }
        }
        .disabled(!(environment.user?.type == .suporter))
      } header: {
        Text(":igyo:サポーター限定機能")
      } footer: {
        Button {
          environment.showPurchaseView = true
        } label: {
          Text(":igyo:サポーターになる")
        }
      }
      Section(header: Text("その他")) {
        Link(destination: URL(string: "https://tsuzuki817.notion.site/f5cf56b582ff43e1b40ce55b56bb2d98")!, label: {
          Text("利用規約")
        })
        Link(destination: URL(string: "https://tsuzuki817.notion.site/326c43c324ec4ae187fb67d03bbca5fe")!, label: {
          Text("プライバシーポリシー")
        })
        Link(destination: URL(string: "https://tsuzuki817.notion.site/7cd2b38f8b724588946a2b6a29645977")!, label: {
          Text("お問い合わせ")
        })
        Link(destination: URL(string: "https://tsuzuki817.notion.site/d19d48fd62954763983acbbe107a8ecb")!, label: {
          Text("免責事項")
        })
        NavigationLink {
          CreditView()
        } label: {
          Text("クレジット")
        }
      }

      Section {
        Button(action: {
          environment.alertType = .multipleButtonError(
            viewData: .init(
              title: "ログアウト",
              message: "本当にログアウトしてもよろしいでしょうか？",
              primaryButtonText: "はい",
              secondaryButtonText: "キャンセル",
              primaryButtonHandler: {
                model.didTapSignOut()
                environment.isLogin = false
                environment.user = nil
              },
              secondaryButtonHandler: {

              })
          )
        }, label: {
          Text("サインアウト")
        })
        .tint(.red)
      }

      Section {
        Button(action: {
          environment.alertType = .multipleButtonError(
            viewData: .init(
              title: "本当に退会しますか？",
              message: "退会するとアカウントは削除され、ログインできなくなります。",
              primaryButtonText: "退会する",
              secondaryButtonText: "キャンセル",
              primaryButtonHandler: {
                Task {
                  await model.didTapWithdrawal {
                    Task { @MainActor in
                      environment.isLogin = false
                      environment.user = nil
                    }
                  }

                }
              },
              secondaryButtonHandler: {

              })
          )
        }, label: {
          Text("退会する")
        })
        .tint(.red)
      }
    }
    .listStyle(.grouped)
    .navigationTitle("設定")
    .navigationBarTitleDisplayMode(.inline)
    .tint(.primary)
    .scrollContentBackground(.hidden)
    .background(Color(.baseBackGround))
    .toolbarBackground(Color(.baseBackGround), for: .navigationBar)
  }
}

#Preview {
  SettingView()
}
