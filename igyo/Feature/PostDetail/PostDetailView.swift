import SwiftUI
import SwiftData

struct PostDetailView: View {
  @State var model: ProfileDetailViewModel = .init(
    noticeUseCase: NoticeUseCase(
      noticeService: NoticeService()
    )
  )
  @EnvironmentObject var environment: AppEnvironment
  @Query(sort: \CachedCategory.index)
  var categories: [CachedCategory] = []

  var post: Post
  var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
  var actionColumns: [GridItem] = Array(repeating: .init(.fixed(64)), count: 5)

  var body: some View {
    ScrollView {
      LazyVStack(pinnedViews: [.sectionHeaders]) {
        Section {
          LazyVGrid(columns: columns) {
            ForEach(model.notice) { notice in
              NavigationLink(value: IgyoPath.userProfile(userID: notice.actionUserID)) {
                ZStack {
                  VStack {
                    NukeImageView(urlStr: notice.actionUserIcon, type: .normal(size: 32, cornerRadius: 16))

                    Text(notice.actionUserName)
                      .fontWeight(.heavy)
                      .font(.caption)
                      .foregroundStyle(.secondary)

                    Spacer()

                    ReactionView(type: notice.action, size: .init(width: 52, height: 32))

                    Text(notice.createdAt.string(for: .difference(to: .init())))
                      .font(.caption)
                      .foregroundStyle(.secondary)
                  }
                  .padding(16)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay {
                  RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 0.1)
                }
              }
              .foregroundStyle(.secondary)
            }
          }
          .padding(.horizontal, 16)
        } header: {
          VStack {
            HStack(alignment: .top, spacing: 12, content: {
              NavigationLink(value: IgyoPath.userProfile(userID: post.userID)) {
                icon()
              }

              content
            })

            reactionsModule

            Divider()
          }
          .background(Color(.baseBackGround))
          .padding(8)
        }

      }
    }
    .navigationTitle("")
    .navigationBarTitleDisplayMode(.inline)
    .task {
      await model.onAppear(post: post)
    }
    .background(Color(.baseBackGround))
    .toolbarBackground(Color(.baseBackGround), for: .navigationBar)
  }

  func icon() -> some View {
    VStack {
      ZStack(alignment: .center) {
        if post.postType == .first {
          Color.red
            .clipShape(Circle())
            .scaleEffect(1.05)
        }

        NukeImageView(urlStr: post.icon, type: .normal(size: 50, cornerRadius: 25))

        if post.postType == .first {
          Image(.tada)
            .resizable()
            .scaledToFit()
            .frame(width: 32, height: 32)
            .offset(x: 20, y: 16)

          Image(.tada)
            .resizable()
            .scaledToFit()
            .frame(width: 32, height: 32)
            .rotation3DEffect(
              .degrees(180),
              axis: (x: 0.0, y: 1.0, z: 0.0)

            )
            .offset(x: -20, y: 16)

        }
      }
      .frame(width: 50, height: 50)
      .overlay(alignment: .bottomTrailing) {
        if post.isPremium == true {
          Image(.premiumBadge)
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
            .offset(x: 4, y: 8)
        }
      }

      if post.postType == .first {
        Text("初投稿")
          .font(.caption)

      }
    }
  }

  var content: some View {
    VStack(alignment: .leading, spacing: 8, content: {
      VStack(alignment: .leading, spacing: 2, content: {
        HStack {
          HStack(spacing: 0) {
            Text(post.name)
              .font(.caption)
            Text("@" + post.userID.prefix(8))
              .font(.caption)
              .foregroundStyle(.secondary)

            Spacer()

            Text(post.createdAt.string(for: .difference(to: Date())))
              .font(.caption)
              .foregroundStyle(.secondary)
          }

          Spacer()

        }

        VStack(alignment: .leading, spacing: 8) {
          IgyoText(text: post.message)

          if let categoryIndex = post.categoryIndex,
             let category = categories.first(where: { $0.index == categoryIndex })?.convert() {
            NavigationLink(value: IgyoPath.categoryDiscover(category: category)) {
              CategoryInputCell(category: category, isLarge: false)
            }
          }
        }
      })

      if !post.images.isEmpty {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack {
            ForEach(post.images, id: \.self) { image in
              Button(action: {
                environment.showImageURL = image
                environment.showViewerURL.toggle()
              }, label: {
                NukeImageView(urlStr: image, type: .normal(size: 120, cornerRadius: 8))

              })
            }
          }
        }
      }
    })
    .padding(.vertical, 4)
  }

  var reactionsModule: some View {
    LazyVGrid(columns: actionColumns, spacing: 8) {

      if let igyoCount = post.igyoCount, igyoCount != 0 {
        actionButton(type: .igyo, count: igyoCount)
      }

      if let sutekiCount = post.sutekiCount, sutekiCount != 0 {
        actionButton(type: .suteki, count: sutekiCount)
      }

      if let kusaCount = post.kusaCount, kusaCount != 0 {
        actionButton(type: .kusa, count: kusaCount)
      }

      if let welcomeCount = post.welcomeCount, welcomeCount != 0 {
        actionButton(type: .welcome, count: welcomeCount)
      }

      if let sugoiCount = post.sugoiCount, sugoiCount != 0 {
        actionButton(type: .sugoi, count: sugoiCount)
      }

      if let goCount = post.goCount, goCount != 0 {
        actionButton(type: .go, count: goCount)
      }

      if let kansyaCount = post.kansyaCount, kansyaCount != 0 {
        actionButton(type: .kansya, count: kansyaCount)
      }

      if let saikyoCount = post.saikyoCount, saikyoCount != 0 {
        actionButton(type: .saikyo, count: saikyoCount)
      }

      if let appareCount = post.appareCount, appareCount != 0 {
        actionButton(type: .appare, count: appareCount)
      }

      if let tensaiCount = post.tensaiCount, tensaiCount != 0 {
        actionButton(type: .tensai, count: tensaiCount)
      }

      if let eraiCount = post.eraiCount, eraiCount != 0 {
        actionButton(type: .erai, count: eraiCount)
      }

      if let iineCount = post.iineCount, iineCount != 0 {
        actionButton(type: .iine, count: iineCount)
      }

      if let otsukareCount = post.otsukareCount, otsukareCount != 0 {
        actionButton(type: .otsukare, count: otsukareCount)
      }

      if let sonkeiCount = post.sonkeiCount, sonkeiCount != 0 {
        actionButton(type: .sonkei, count: sonkeiCount)
      }

      if let wakaruCount = post.wakaruCount, wakaruCount != 0 {
        actionButton(type: .wakaru, count: wakaruCount)
      }
    }
  }

  private func actionButton(type: ActionType, count: Int) -> some View {
    ZStack {
      HStack(alignment: .center, spacing: 2) {
        ReactionView(type: type)
        if count != 0 {
          Text(String(count))
            .font(.caption)
            .lineLimit(1)
            .minimumScaleFactor(0.1)
        }
      }
      .padding(.vertical, 4)
      .padding(.horizontal, 12)
    }
    .overlay {
      if environment.isReaction(postID: post.id, type: type) {
        Color.secondary.opacity(0.45)
          .clipShape( RoundedRectangle(cornerRadius: 32))
      }
    }
    .background(
      RoundedRectangle(cornerRadius: 32)
        .stroke(lineWidth: 1)
        .foregroundStyle(.secondary.opacity(0.6))
    )
  }

}

#Preview {
  PostDetailView(post: .stub)
}
