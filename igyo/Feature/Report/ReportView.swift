import SwiftUI

struct ReportView: View {
  var post: Post
  @State var model: ReportViewModel = .init(
    useCase: ReportUseCase(
      reportService: ReportService()
    )
  )
  @EnvironmentObject var environment: AppEnvironment
  @Environment(\.dismiss) var dismiss

  var body: some View {
    VStack(spacing: 0) {
      HStack {
        NukeImageView(
          urlStr: post.icon,
          type: .normal(size: 40, cornerRadius: 20)
        )

        VStack(alignment: .leading, content: {
          HStack {
            Text(post.name)
              .font(.caption)
            Text("@" + post.userID.prefix(8))
              .font(.caption)
              .foregroundStyle(.secondary)

          }
          Text(post.message)
            .font(.caption)
        })

        Spacer()
      }
      .padding(16)
      .background(Color(.baseBackGround))

      List {
        ForEach(ReportType.all, id: \.rawValue) { type in
          Button(action: {
            model.selected = type
          }, label: {
            HStack {
              Text(type.title)
              Spacer()
              if model.selected == type {
                Image(systemName: "checkmark")
              }
            }
          })
          .tint(.primary)
        }
      }
      .listStyle(.grouped)
      .scrollContentBackground(.hidden)
      .background(Color(.baseBackGround))
    }
    .navigationTitle("違反申告")
    .navigationBarTitleDisplayMode(.inline)
    .safeAreaInset(edge: .bottom) {
      Button(role: .destructive, action: {
        Task {
          await model.didTapSubmitButton(post: post, user: environment.user) {
            Task { @MainActor in
              environment.alertType = .defaultError(
                viewData: .init(
                  title: "報告完了",
                  message: "ありがとうございます。運営側で確認させていただきます。"
                  , buttonText: "閉じる",
                  handler: {
                    dismiss()
                  }
                )
              )
            }
          }
        }
      }, label: {
        Text("申告する")
          .frame(maxWidth: .infinity)
          .fontWeight(.bold)
      })
      .frame(height: 52)
      .buttonStyle(.borderedProminent)
      .disabled(model.selected == nil)
      .padding(8)
      .padding(.bottom, 50)
      .scrollContentBackground(.hidden)
      .background(Color(.baseBackGround))
      .toolbarBackground(Color(.baseBackGround), for: .navigationBar)
    }
  }
}

#Preview {
  ReportView(post: .stub)
}
