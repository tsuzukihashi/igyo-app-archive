import SwiftUI

struct SetupView: View {
  @EnvironmentObject var environment: AppEnvironment
  @State var model: SetupViewModel = .init(
    useCase: SetupUseCase(
      userService: UserService(),
      iconService: IconService()
    )
  )
  @FocusState var isFocused: Bool
  var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)

  var body: some View {
    VStack(spacing: 32) {
      if model.icons.isEmpty {
        ProgressView()
      } else {

        VStack {
          if let selected = model.selectedIcon {
            NukeImageView(
              urlStr: selected.imageURL,
              type: .normal(size: 120, cornerRadius: 60)
            )

            TextField("なまえ", text: $model.name)
              .focused($isFocused)
              .multilineTextAlignment(.center)
              .textFieldStyle(.roundedBorder)
              .submitLabel(.done)
              .overlay(alignment: .trailing, content: {
                Button {
                  model.name = ""
                  isFocused = true
                } label: {
                  Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .padding(4)
                }
                .tint(.primary)
              })
              .padding(.horizontal, 32)
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
                }
              })
              .tint(.primary)
            }
          }
        }
        .frame(height: 300)

        Button(action: {
          Task {
            await model.didTapSubmitButton(uid: environment.user?.id)
            environment.user?.name = model.name
            environment.user?.iconID = model.selectedIcon?.id
            environment.user?.imageUrl = model.selectedIcon?.imageURL ?? ""
          }
        }, label: {
          Text("はじめる")
            .fontWeight(.heavy)
            .frame(maxWidth: .infinity)
            .frame(height: 30)
        })
        .buttonStyle(.borderedProminent)
        .tint(.orange)
        .disabled(model.name == "")
        .padding(.horizontal)
      }
    }
    .task {
      model.name = environment.user?.name ?? ""
      await model.onAppear()
    }
    .scrollDismissesKeyboard(.immediately)
    .scrollContentBackground(.hidden)
    .background(Color(.baseBackGround))
    .toolbarBackground(Color(.baseBackGround), for: .navigationBar)
  }
}

#Preview {
  SetupView()
}
