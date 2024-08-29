import SwiftUI

struct SideMenuView: View {
  @EnvironmentObject var environment: AppEnvironment

  var body: some View {
    VStack(alignment: .leading, spacing: 32, content: {
      if let user = environment.user {
        VStack(alignment: .leading, spacing: 4) {
          HStack {
            NukeImageView(urlStr: user.imageUrl, type: .normal(size: 44, cornerRadius: 22))
              .padding(1)
              .overlay {
                Circle()
                  .stroke(lineWidth: 1)
                  .foregroundStyle(.white)
              }
            Spacer()
          }
          Text(user.name)
            .font(.title)
          Text("@" + (user.id?.prefix(8) ?? ""))
            .font(.caption)
        }
      }
      VStack(alignment: .leading, spacing: 16) {
        Button {
          environment.showMenu = false
          environment.paths.append(.mypage)
        } label: {
          Label("プロフィール", systemImage: "person")
            .font(.title2)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .tint(.primary)

        Button {
          environment.showMenu = false
          environment.paths.append(.discover)
        } label: {
          Label("探索", systemImage: "magnifyingglass")
            .font(.title2)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .tint(.primary)

        Button {
          environment.showMenu = false
          environment.paths.append(.notice)
        } label: {
          Label("通知", systemImage: "bell")
            .font(.title2)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .tint(.primary)

        if let userID = environment.user?.id {
          Button {
            environment.showMenu = false
            environment.paths.append(.actionsList(userID: userID))
          } label: {
            Label("アクションリスト", systemImage: "list.bullet.rectangle")
              .font(.title2)
              .frame(maxWidth: .infinity, alignment: .leading)
          }
          .tint(.primary)
        }

        Button {
          environment.showMenu = false
          environment.paths.append(.settings)
        } label: {
          Label("設定", systemImage: "gear")
            .font(.title2)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .tint(.primary)

        Button {
          environment.showMenu = false
          environment.showPurchaseView = true
        } label: {
          Label(":igyo:サポーター", systemImage: "dollarsign.circle.fill")
            .font(.title2)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .tint(.primary)
      }

      Spacer()
    })
    .padding(.vertical, 64)
    .padding(.horizontal, 16)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.baseBackGround))
    .opacity(environment.showMenu ? 1 : 0)
    .animation(.easeIn, value: environment.showMenu)
  }
}

#Preview {
  SideMenuView()
}
