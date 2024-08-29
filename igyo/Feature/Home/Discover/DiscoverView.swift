import SwiftUI

struct DiscoverView: View {
  @State var model: DiscoverViewModel = .init(
    useCase: DiscoverUseCase(
      userService: UserService(), 
      postService: PostService()
    )
  )

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16, content: {
        VStack(alignment: .leading, spacing: 4, content: {
          Text("新着ユーザー")
            .font(.headline)
          Text("Welcomeスタンプを連打して歓迎しよう！")
            .font(.caption)
            .foregroundStyle(.secondary)
        })

        ForEach(model.displayUsers) { user in
          NavigationLink(value: IgyoPath.userProfile(userID: user.id ?? "")) {
            HStack {
              NukeImageView(urlStr: user.imageUrl, type: .normal(size: 60, cornerRadius: 30))

              VStack(alignment: .leading) {
                Text(user.name)
                Text(user.description)
              }

              Spacer()
            }
          }
          .foregroundStyle(.secondary)
        }
      })
      .padding(16)
    }
    .frame(maxWidth: .infinity)
    .task {
      await model.onAppear()
    }
    .refreshable {
      Task {
        await model.pullToRefresh()
      }
    }
    .navigationTitle("Discover")
    .navigationBarTitleDisplayMode(.inline)
    .background(Color(.baseBackGround))
    .toolbarBackground(Color(.baseBackGround), for: .navigationBar)
  }
}

#Preview {
  DiscoverView()
}
