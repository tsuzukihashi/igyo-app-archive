import SwiftData
import SwiftUI
import TipKit

struct TimelineView: View {
  @State var model: TimelineViewModel = .init(
    useCase: TimelineUseCase(
      postService: PostService(),
      noticeService: NoticeService(),
      userService: UserService()
    ),
    categoryUseCase: CategoryUseCase(
      service: CategoryService()
    )
  )
  @State var shouldUpdate: Bool = false

  @EnvironmentObject var environment: AppEnvironment
  @Query(sort: \CachedCategory.index) var categories: [CachedCategory]
  @Environment(\.modelContext) private var modelContext

  var body: some View {
    NavigationStack(path: $environment.paths) {
      ScrollView(showsIndicators: false) {
        LazyVStack {
          if !environment.isPremiumUser, environment.launchCount % 2 == 0 {
            BannerView(type: .home)
              .frame(height: 250)
          }
          ForEach(model.posts) { post in
            PostCellView(
              post: post,
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
            .task {
              await model.nextFetchIfNeeded(post: post)
            }
          }
          Spacer(minLength: 50)
        }
        .padding()
      }
      .scrollContentBackground(.hidden)
      .background(Color(.baseBackGround))
      .refreshable {
        Task {
          await model.pullToRefresh()
        }
      }
      .overlay(alignment: .bottomTrailing) {
        HStack {
          TipView(TimelinePostButtonTips(), arrowEdge: .trailing)

          Button {
            model.showPostScreen.toggle()
          } label: {
            LoopLottieView(name: "start")
              .frame(width: 44, height: 44)
              .padding(8)
              .background(Color(.startButtonBG))
              .clipShape(Circle())
          }
        }
        .padding(16)
      }
      .navigationTitle(Text("Home"))
      .navigationBarTitleDisplayMode(.inline)
      .navigationDestination(for: IgyoPath.self) { route in
        switch route {
        case .settings:
          SettingView()
        case .discover:
          DiscoverView()
        case .notice:
          NoticeView()
        case .mypage:
          MyPageView(user: environment.user)
        case .userProfile(userID: let userID):
          UserPageView(userID: userID)
        case .detail(let post):
          PostDetailView(post: post)
        case .report(let post):
          ReportView(post: post)
        case .nameEditor:
          UserNameEditorView()
        case .iconEditor:
          IconEditor()
        case .blockList:
          BlockListView()
        case .hiddenList:
          HiddenListView()
        case .reportList:
          ReportListView()
        case .actionsList(let userID):
          ActionsListView(userID: userID)
        case .categoryDiscover(let category):
          DiscoverCategoryView(category: category)
        case .premiumIconEditor:
          PremiumIconEditorView()
        }
      }
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            environment.showMenu = true
          } label: {
            if let imageURL = environment.user?.imageUrl {
              NukeImageView(urlStr: imageURL, type: .normal(size: 32, cornerRadius: 16))
                .padding(1)
                .overlay {
                  Circle()
                    .stroke(lineWidth: 1)
                    .foregroundStyle(.white)
                }
            } else {
              Label("あなた", systemImage: "person")
            }
          }
        }
        ToolbarItem(placement: .topBarTrailing) {
          NavigationLink(value: IgyoPath.discover) {
            Image(.megane)
              .resizable()
              .scaledToFit()
              .frame(width: 32, height: 32)
          }
        }
        ToolbarItem(placement: .topBarTrailing) {
          NavigationLink(value: IgyoPath.notice) {
            Image(.bell)
              .resizable()
              .scaledToFit()
              .frame(width: 32, height: 32)
          }
        }
      }
      .task {
        await model.onAppear()
        if categories.isEmpty {
          let categories = await model.fetchCategory()
          for category in categories {
            modelContext.insert(category)
          }
        }
        
        try? Tips.configure([
          .displayFrequency(.immediate),
          .datastoreLocation(.applicationDefault)
        ])
      }
      .sheet(item: $model.selectedPost) { post in
        ActionTypeSheet(post: post) { type in
          await model.didTapAction(post: post, user: environment.user, type: type)
        }
      }
      .sheet(isPresented: $model.showPostScreen, onDismiss: {
        Task {
          if shouldUpdate {
            await model.pullToRefresh()
          }
        }
      }, content: {
        CreateView(shouldUpdate: $shouldUpdate)
      })
      .toolbarBackground(Color(.baseBackGround), for: .navigationBar)
    }
  }
}

#Preview {
  TimelineView()
    .environmentObject(AppEnvironment.shared)
}
