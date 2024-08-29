import SwiftUI

struct NoticeActionsCell: View {
  let notice: Notice

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        let imageSize: CGFloat = 44
        NavigationLink(value: IgyoPath.userProfile(userID: notice.postUserID)) {
          NukeImageView(
            urlStr: notice.postUserIcon,
            type: .normal(size: imageSize, cornerRadius: imageSize / 2)
          )
          .frame(width: imageSize, height: imageSize)
        }

        VStack(alignment: .leading) {
          Text(notice.postUserName)
          IgyoText(text: notice.postMessage)
        }
        Spacer()
      }

      HStack {
        Spacer()
        Text(notice.createdAt.string(for: .yyyyMMddEEEHHmm))
          .font(.caption)
      }

      Divider()
    }
    .padding(8)
  }
}

#Preview {
  NoticeActionsCell(notice: .stub)
}
