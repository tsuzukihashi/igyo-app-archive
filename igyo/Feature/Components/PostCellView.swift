import SwiftUI
import SwiftData

struct PostCellView: View {
  @Query(sort: \CachedCategory.index)
  var categories: [CachedCategory] = []

  @EnvironmentObject var environment: AppEnvironment
  var post: Post
  var showCategory: Bool = true
  var didTapAction: (ActionType) async -> Void
  var didTapUnAction: (ActionType) async -> Void
  var didTapPostAction: (PostActionType) async -> Void
  var didTapBubble: () -> Void
  var columns: [GridItem] = Array(repeating: .init(.fixed(64)), count: 4)

  var body: some View {
    VStack {
      HStack(alignment: .top, spacing: 12, content: {
        NavigationLink(value: IgyoPath.userProfile(userID: post.userID)) {
          icon()
        }
        .foregroundStyle(.secondary)

        content
      })
      reactionModule
      Divider()
    }
    .background(
      NavigationLink(value: IgyoPath.detail(post: post), label: {
        Color.white.opacity(0.00001)
      })
    )
    .background(Color(.baseBackGround))
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
    .padding(.top, 8)
  }

  private func actionButton(type: ActionType, count: Int) -> some View {
    Button(action: {
      guard post.userID != environment.user?.id else { return }
      Task {
        if environment.isReaction(postID: post.id, type: type) {
          await didTapUnAction(type)
        } else {
          await didTapAction(type)
        }
      }
    }, label: {
      ZStack {
        HStack(alignment: .center, spacing: 2) {
          ReactionView(type: type)

          Text(String(count))
            .font(.caption)
            .lineLimit(1)
            .minimumScaleFactor(0.1)
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
    })
    .tint(environment.isReaction(postID: post.id, type: type) ? .secondary : .primary)
    .disabled(post.userID == environment.user?.id)
  }

  var content: some View {
    VStack(alignment: .leading, spacing: 8, content: {
      VStack(alignment: .leading, spacing: 4, content: {
        userInfoModule

        VStack(alignment: .leading, spacing: 8) {
          IgyoText(text: post.message)
            .lineLimit(10)
            .onTapGesture {
              environment.paths.append(.detail(post: post))
            }

          if showCategory,
            let categoryIndex = post.categoryIndex,
             let category = categories.first(where: { $0.index == categoryIndex })?.convert() {
            NavigationLink(value: IgyoPath.categoryDiscover(category: category)) {
              CategoryInputCell(category: category, isLarge: false)
            }
          }
        }
      })

      if !post.images.isEmpty {
        HStack {
          ForEach(post.images, id: \.self) { image in
            Button(action: {
              environment.showImageURL = image
              environment.showViewerURL.toggle()
            }, label: {
              NukeImageView(urlStr: image, type: .rectangle(size: .init(width: 300, height: 200), cornerRadius: 20))
            })
          }
        }
      }
    })
    .padding(.vertical, 4)
  }

  var reactionModule: some View {
    HStack {
      LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
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

      Spacer()

      Button {
        didTapBubble()
      } label: {
        Image(systemName: "plus.bubble.fill")
          .tint(.primary)
          .rotation3DEffect(
            .degrees(180),
            axis: (x: 0.0, y: 1.0, z: 0.0)
          )
          .padding(8)
      }
      .opacity(post.userID != environment.user?.id ? 1 : 0)
    }
    .padding(.horizontal, 8)
  }

  var userInfoModule: some View {
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

      ellipseMenu
    }
  }

  var ellipseMenu: some View {
    Menu {
      if post.userID == environment.user?.id {
        Button(action: {
          Task {
            await didTapPostAction(.delete)
          }
        }, label: {
          Text("削除する")
        })
      } else {
        NavigationLink(value: IgyoPath.report(post: post)) {
          Text("違反申告")
        }

        Button(action: {
          Task {
            await didTapPostAction(.hidden)
          }
        }, label: {
          Text("この投稿を非表示にする")
        })
      }
    } label: {
      Image(systemName: "ellipsis")
        .padding(8)
    }
    .foregroundStyle(.primary)

  }
}
