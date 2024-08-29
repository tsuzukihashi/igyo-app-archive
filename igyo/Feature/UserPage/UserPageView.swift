import SwiftUI

struct UserPageView: View {
  let userID: String
  @EnvironmentObject var environment: AppEnvironment
  @Environment(\.dismiss) var dismiss
  @State var model: UserPageViewModel = .init(
    useCase: UserPageUseCase(
      userService: UserService(),
      postService: PostService()
    ), timelineUseCase: TimelineUseCase(
      postService: PostService(),
      noticeService: NoticeService(),
      userService: UserService()
    )
  )

  var body: some View {
    ScrollView(showsIndicators: false) {
      userIcon

      if environment.blockIDs.contains(where: { $0 == userID }) {
        blockedUserCell
      } else {
        normalUserCell
      }
    }
    .refreshable {
      Task {
        await model.pullToRefresh(id: userID)
      }
    }
    .padding(.horizontal, 16)
    .navigationTitle((model.user?.name ?? "xxx") + "のページ")
    .navigationBarTitleDisplayMode(.inline)
    .scrollContentBackground(.hidden)
    .background(Color(.baseBackGround))
    .toolbarBackground(Color(.baseBackGround), for: .navigationBar)
    .toolbar(content: {
      ToolbarItem(placement: .topBarTrailing) {
        Button(role: .destructive) {
          environment.alertType = .multipleButtonError(viewData: MultipleButtonErrorViewData(title: "このユーザーをブロックしますか？", message: "ブロックするとこのユーザーの投稿が表示されなくなります", primaryButtonText: "ブロックする", secondaryButtonText: "キャンセル", primaryButtonHandler: {
            Task { @MainActor in
              model.didTapBlock(id: userID) {
                Task { @MainActor in
                  dismiss()
                }
              }
            }
          }, secondaryButtonHandler: {

          }))
        } label: {
          Image(systemName: "person.slash.fill")
            .padding(8)
        }
        .disabled(
          !model.showBlockButton(
            userID: userID,
            blockIDs: environment.blockIDs,
            myID: environment.user?.id
          )
        )
        .tint(.red)
      }
    })
    .task {
      await model.onAppear(id: userID)
    }
    .sheet(item: $model.selectedPost) { post in
      ActionTypeSheet(post: post) { type in
        await model.didTapAction(post: post, user: environment.user, type: type)
      }
    }
  }

  var userIcon: some View {
    LazyVStack(alignment: .center, spacing: 8) {
      HStack {
        VStack(alignment: .leading) {
          Text(model.user?.name ?? "")
            .font(.headline)
          Text("@" + (model.user?.id?.prefix(8) ?? ""))
            .font(.caption)
            .foregroundStyle(.secondary)
          Text(model.user?.description ?? "")
          Spacer()

          HStack {
            Text("成した偉業:")
            Text("\(model.user?.postCount ?? 0)")
              .fontDesign(.monospaced)

            Text("褒めた回数:")
            Text("\(model.user?.reactionCount ?? 0)")
              .fontDesign(.monospaced)

            Spacer()
          }
          .font(.caption)
        }
        Spacer()

        NukeImageView(urlStr: model.user?.imageUrl ?? "", type: .normal(size: 100, cornerRadius: 50))
      }
    }
  }

  var blockedUserCell: some View {
    VStack {
      Spacer()
      Text("ブロックしているユーザー")

      Button(role: .destructive) {
        environment.blockIDs.removeAll(where: { $0 == userID })
        dismiss()
      } label: {
        Text("ブロックを解除する")
      }
      .buttonStyle(.borderedProminent)
      Spacer()
    }
  }

  var normalUserCell: some View {
    LazyVStack(pinnedViews: [], content: {
      Section {
        ForEach(model.posts) { post in
          PostCellView(
            post: post,
            didTapAction: { type in
              await model.didTapAction(post: post, user: environment.user, type: type)
            }, didTapUnAction: { type in
              await model.didTapUnAction(post: post, user: environment.user, type: type)
            }, didTapPostAction: {type in
              await model.didTapPostAction(post: post, type: type)
            }) {
              model.selectedPost = post
            }
        }
      }
    })
  }

}

#Preview {
  UserPageView(userID: "")
}
