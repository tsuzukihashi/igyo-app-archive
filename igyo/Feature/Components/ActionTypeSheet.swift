import SwiftUI

struct ActionTypeSheet: View {
  @EnvironmentObject var environment: AppEnvironment
  @Environment(\.dismiss) var dismiss

  var post: Post
  var didTapAction: (ActionType) async -> Void
  private let sheetColumns: [GridItem] = Array(repeating: .init(.fixed(64)), count: 5)

  var body: some View {
    VStack {
      LazyVGrid(columns: sheetColumns, spacing: 8) {
        ForEach(ActionType.all, id: \.rawValue) { type in
          Button {
            Task {
              await didTapAction(type)
              dismiss()
            }
          } label: {
            ZStack {
              HStack(alignment: .center, spacing: 2) {
                ReactionView(type: type)
              }
              .padding(.vertical, 4)
              .padding(.horizontal, 12)

              if environment.isReaction(postID: post.id, type: type) {
                RoundedRectangle(cornerRadius: 32)
                  .foregroundStyle(.secondary)
                  .frame(width: 24 + 12*2)
              }
            }
            .background(
              RoundedRectangle(cornerRadius: 32)
                .stroke(lineWidth: 1)
                .foregroundStyle(.secondary.opacity(0.6))
            )
          }
          .tint(.primary)
          .disabled(post.userID == environment.user?.id || environment.isReaction(postID: post.id, type: type))
        }
      }
    }
    .presentationDetents([.height(160)])
  }
}
