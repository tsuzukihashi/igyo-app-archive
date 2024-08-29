import SwiftUI

struct IconEditor: View {
  @EnvironmentObject var environment: AppEnvironment
  @State var model: IconEditorViewModel = .init(
    useCase: IconEditorUseCase(
      userService: UserService(),
      iconService: IconService()
    )
  )
  @Environment(\.dismiss) var dismiss

  var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)

  var body: some View {
    VStack(spacing: 16) {
      if model.icons.isEmpty {
        LoopLottieView(name: "loading")
          .frame(height: 300)
      } else {
        VStack {
          if let selected = model.selectedIcon {
            NukeImageView(
              urlStr: selected.imageURL,
              type: .normal(size: 120, cornerRadius: 60)
            )
            Text(selected.name)
          }
        }

        ScrollView {
          LazyVGrid(columns: columns) {
            ForEach(model.icons) { icon in
              Button(action: {
                model.didTapIcon(icon: icon)
              }, label: {
                VStack {
                  NukeImageView(urlStr: icon.imageURL, type: .normal(size: 80, cornerRadius: 40))
                    .background(
                      Circle()
                        .foregroundStyle(.orange)
                        .scaleEffect(model.selectedIcon == icon ? 1.1 : 0)
                    )
                    .frame(width: 90, height: 90)

                  Text(icon.name)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .fontWeight(model.selectedIcon == icon ? .heavy : .light)

                  Spacer()
                }
              })
              .tint(.primary)
            }
          }
        }
        .frame(maxHeight: .infinity)

        VStack(spacing: 4) {
          Text("アイコンを変更しても、過去に投稿したアイコンまでは変わりません。\n今後投稿するアイコンにのみ変更が適応されます。")
            .lineLimit(3)
            .font(.caption)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.leading)

          Button(action: {
            Task {
              await model.didTapSubmitButton(uid: environment.user?.id) {
                Task { @MainActor in
                  environment.user?.iconID = model.selectedIcon?.id
                  environment.user?.imageUrl = model.selectedIcon?.imageURL ?? ""
                  environment.nameChangeAnimation = true
                  dismiss()
                }
              }
            }
          }, label: {
            Text("変更する")
              .fontWeight(.heavy)
              .frame(maxWidth: .infinity)
              .frame(height: 30)
          })
          .buttonStyle(.borderedProminent)
          .tint(.orange)
        }
        .padding(.horizontal)
      }
    }
    .task {
      await model.onAppear(iconID: environment.user?.iconID)
    }
    .scrollContentBackground(.hidden)
    .background(Color(.baseBackGround))
    .toolbarBackground(Color(.baseBackGround), for: .navigationBar)
  }
}

#Preview {
  IconEditor()
}
