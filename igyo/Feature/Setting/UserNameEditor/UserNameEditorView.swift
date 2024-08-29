import SwiftUI

struct UserNameEditorView: View {
  @State var model: UserNameEditorViewModel = .init(
    useCase: UserNameUseCase(userService: UserService())
  )
  @FocusState var isFocuesd: Bool
  @EnvironmentObject var environment: AppEnvironment
  @Environment(\.dismiss) var dismiss

  var body: some View {

    VStack(alignment: .leading) {
      Text("ユーザ名")
      TextField(
        "公序良俗に反しない名前",
        text: $model.name
      )
      .textFieldStyle(.roundedBorder)
      .focused($isFocuesd)
      .submitLabel(.done)
      .onChange(of: model.name) { _, _ in
        model.onChange()
      }

      Text(model.validationMessage)
        .font(.caption)
        .foregroundStyle(.red)

      Spacer()

      VStack(spacing: 4) {
        Text("ユーザ名を変更しても、過去に投稿したユーザ名までは変わりません。\n今後投稿するユーザ名にのみ変更が適応されます。")
          .lineLimit(3)
          .font(.caption)
          .foregroundStyle(.secondary)
          .multilineTextAlignment(.leading)
        Button {
          Task {
            await model.didTapSubmitButton(user: environment.user) {
              Task { @MainActor in
                environment.user?.name = model.name
                environment.nameChangeAnimation = true
                dismiss()
              }
            }
          }
        } label: {
          Text("変更する")
            .fontWeight(.heavy)
            .frame(maxWidth: .infinity)
            .frame(height: 32)
        }
        .disabled(model.validationMessage != "")
        .buttonStyle(.borderedProminent)
        .tint(.orange)
      }
    }
    .padding(16)
    .task {
      isFocuesd = true
      model.onAppear(user: environment.user)
    }
    .scrollContentBackground(.hidden)
    .background(Color(.baseBackGround))
    .toolbarBackground(Color(.baseBackGround), for: .navigationBar)
  }
}

#Preview {
  UserNameEditorView()
}
