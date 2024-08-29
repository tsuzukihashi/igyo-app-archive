import SwiftUI
import ImagePickerSwiftUI

struct PremiumIconEditorView: View {
  @EnvironmentObject var environment: AppEnvironment
  @State var model: PremiumIconEditorViewModel = .init(
    userCase: PremiumIconEditorUseCase(
      userService: UserService(),
      imageService: ImageService()
    )
  )
  @Environment(\.dismiss) var dismiss

  var body: some View {
    ScrollView {
      LazyVStack {
        if let image = model.selectedImage {
          Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: 300, height: 300)
            .clipShape(Circle())
            .padding(32)
        } else if let user = environment.user {
          NukeImageView(urlStr: user.imageUrl, type: .normal(size: 300, cornerRadius: 150))
            .padding(32)
        }
      }
    }
    .overlay(alignment: .bottom, content: {
      VStack {
        Button {
          model.showPhotoSelect.toggle()
        } label: {
          Label("画像を選ぶ", systemImage: "photo.stack")
            .padding(.vertical, 8)
            .frame(width: 300)
            .foregroundStyle(.black)
        }
        .buttonStyle(.borderedProminent)
        .tint(.white)

        Button {
          Task {
            await model.update(user: environment.user)
          }
        } label: {
          Text("更新する")
            .padding(.vertical, 8)
            .frame(width: 300)
        }
        .buttonStyle(.borderedProminent)
        .tint(.orange)
      }
      .padding(32)
    })
    .background(Color(.baseBackGround))
    .toolbarBackground(Color(.baseBackGround), for: .navigationBar)
    .fullScreenCover(isPresented: $model.showImagePicker) {

    } content: {
      ImagePickerSwiftUI(
        selectedImage: $model.selectedImage,
        sourceType: .camera,
        allowsEditing: false,
        key: .originalImage,
        croppingToSquare: false
      )
      .edgesIgnoringSafeArea(.all)
      .tint(.accentColor)
    }
    .fullScreenCover(isPresented: $model.showAlbumImagePicker) {

    } content: {
      ImagePickerSwiftUI(
        selectedImage: $model.selectedImage,
        sourceType: .photoLibrary,
        allowsEditing: false,
        key: .originalImage,
        croppingToSquare: false
      )
      .edgesIgnoringSafeArea(.all)
      .tint(.accentColor)
    }
    .confirmationDialog("アイコンに選ぶ画像を選択する", isPresented: $model.showPhotoSelect) {
      Button {
        model.showAlbumImagePicker.toggle()
      } label: {
        Label("アルバム", systemImage: "person.2.crop.square.stack")
      }
      Button {
        model.showImagePicker.toggle()
      } label: {
        Label("カメラ", systemImage: "person.crop.square.badge.camera")
      }
    }
    .alert(model.message, isPresented: $model.showMessage) {
      Button {
        dismiss()
      } label: {
        Text("OK")
      }

    }
  }
}

#Preview {
  PremiumIconEditorView()
}
