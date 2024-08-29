import SwiftUI

struct MyPageView: View {
  @EnvironmentObject var environment: AppEnvironment
  @State var model: MyPageViewModel = .init(
    useCase: MyPageUseCase(
      postService: PostService(),
      userService: UserService()
    )
  )
  var user: User?

  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      LazyVStack(alignment: .center, spacing: 8) {
        if let user {
          HStack {
            VStack(alignment: .leading) {
              Text(user.name)
                .font(.headline)
              Text("@" + (user.id?.prefix(8) ?? ""))
                .font(.caption)
                .foregroundStyle(.secondary)

              Text(user.description)
              Spacer()
              HStack {
                Text("成した偉業:")
                Text("\(user.postCount)")
                  .fontDesign(.monospaced)

                Text("褒めた回数:")
                Text("\(user.reactionCount)")
                  .fontDesign(.monospaced)
                Spacer()
              }
              .font(.caption)

              if user.type == .suporter {
                Text("あなたは:igyo:サポーターです🥇")
                  .font(.caption)
              }
            }
            Spacer()

            NukeImageView(urlStr: user.imageUrl, type: .normal(size: 100, cornerRadius: 50))
              .overlay(alignment: .bottomTrailing) {
                if user.type == .suporter {
                  Image(.premiumBadge)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .offset(x: 4, y: 8)
                }
              }
          }

          if model.posts.isEmpty {
            Spacer()

            LoopLottieView(name: "empty")
              .frame(width: 200, height: 200)
              .clipShape(RoundedRectangle(cornerRadius: 16))
            Text("Homeに戻って投稿してみよう！")

            Button(action: {
              environment.paths = []
            }, label: {
              Text("Home🏃‍♀️")
            })

          } else {
            LazyVStack(pinnedViews: [], content: {
              Section {
                ForEach(model.posts) { post in
                  PostCellView(
                    post: post,
                    didTapAction: { _ in
                    }, didTapUnAction: { _ in
                    }, didTapPostAction: { type in
                      switch type {
                      case .delete:
                        Task {
                          await model.didTapDelete(id: post.id)
                        }
                      default:
                        break
                      }
                    }, didTapBubble: {}
                  )
                }
              }
            })
          }
        } else {
          notLoginView
        }
      }
      .padding(16)
    }
    .refreshable {
      Task {
        await model.pullToRefresh(user: user)
      }
    }
    .navigationTitle("MyPage")
    .navigationBarTitleDisplayMode(.inline)
    .scrollContentBackground(.hidden)
    .background(Color(.baseBackGround))
    .toolbarBackground(Color(.baseBackGround), for: .navigationBar)
    .task {
      await model.onAppear(user: user)
    }
  }

  var notLoginView: some View {
    Text("未ログイン")
  }
}

#Preview {
  MyPageView(user: .stub0)
}
