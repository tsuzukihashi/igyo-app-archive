import SwiftUI

struct DiscoverCategoryView: View {
  let category: Category
  @EnvironmentObject var environment: AppEnvironment
  @State var model: DiscoverCategoryViewModel = .init(
    useCase: TimelineUseCase(
      postService: PostService(),
      noticeService: NoticeService(),
      userService: UserService()
    ), discoverUseCase: DiscoverUseCase(
      userService: UserService(),
      postService: PostService()
    )
  )

  var body: some View {
    ScrollView {
      LazyVStack {
        ForEach(model.posts) { post in
          PostCellView(
            post: post,
            showCategory: false,
            didTapAction: { type in
              await model.didTapAction(post: post, user: environment.user, type: type)
            }, didTapUnAction: { type in
              await model.didTapUnAction(post: post, user: environment.user, type: type)
            }, didTapPostAction: { type in
              await model.didTapPostAction(post: post, type: type)
            }, didTapBubble: {
              model.selectedPost = post
            }
          )
          .id(post.id)
        }
      }
      .padding(.horizontal, 8)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.baseBackGround))
    .toolbarBackground(Color(.baseBackGround), for: .navigationBar)
    .navigationTitle(category.title)
    .task {
      await model.onAppear(category: category)
    }
    .sheet(item: $model.selectedPost) { post in
      ActionTypeSheet(post: post) { type in
        await model.didTapAction(post: post, user: environment.user, type: type)
      }
    }
  }
}

#Preview {
  DiscoverCategoryView(category: .stub)
}
