import SwiftUI

struct NoticeCell: View {
  let notice: Notice
  var body: some View {
    VStack {
      HStack(spacing: 8) {
        VStack {
          ReactionView(type: notice.action)
          NavigationLink(value: IgyoPath.userProfile(userID: notice.actionUserID)) {
            NukeImageView(
              urlStr: notice.actionUserIcon,
              type: .normal(size: 60, cornerRadius: 30)
            )
            .overlay(alignment: .bottomTrailing) {
              if notice.isPremiumAction == true {
                Image(.premiumBadge)
                  .resizable()
                  .scaledToFit()
                  .frame(width: 24, height: 24)
                  .offset(x: 4, y: 8)
              }
            }
          }
        }

        VStack(alignment: .leading) {
          VStack(alignment: .leading) {
            Text(notice.actionUserName + "があなたの投稿にリアクションしました！")

            HStack {
              Spacer()
              Text(notice.createdAt.string(for: .difference(to: Date())))
                .font(.caption)
                .foregroundStyle(.secondary)
            }
          }

          HStack {
            NukeImageView(
              urlStr: notice.postUserIcon,
              type: .normal(size: 30, cornerRadius: 15)
            )
            VStack(alignment: .leading) {
              Text(notice.postUserName)
                .font(.caption)

              Text(notice.postMessage)
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            Spacer()
          }
          .padding(8)
          .overlay {
            RoundedRectangle(cornerRadius: 8)
              .stroke(lineWidth: 0.1)
              .foregroundStyle(.secondary)
          }

        }

        Spacer()
      }

      Divider()
    }
  }
}
