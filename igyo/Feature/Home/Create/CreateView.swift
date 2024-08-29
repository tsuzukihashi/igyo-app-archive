import SwiftUI
import SwiftData

import ImagePickerSwiftUI

struct CreateView: View {
  @AppStorage("isAutoGenerateCategory") var isAutoGenerateCategory: Bool = true
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject var environment: AppEnvironment
  @State var model: CreateViewModel = .init(
    useCase: CreateUseCase(
      userService: UserService(),
      postService: PostService(),
      imageService: ImageService()
    )
  )
  @Query(sort: \CachedCategory.index) var categories: [CachedCategory] = []

  @State var geminiModel: GeminiViewModel = .init()
  @FocusState var isFocused: Bool
  @Binding var shouldUpdate: Bool

  var body: some View {
    NavigationView {
      ScrollView {
        VStack(spacing: 0) {
          if let user = environment.user {
            HStack {
              NukeImageView(urlStr: user.imageUrl, type: .normal(size: 50, cornerRadius: 25))
              VStack(alignment: .leading) {
                Text(user.name)
                  .font(.caption)
                Text("@" + (user.id?.prefix(8) ?? ""))
                  .font(.caption)
                  .foregroundStyle(.secondary)
              }
              
              Spacer()
            }
            
            TextEditor(text: $model.message)
              .focused($isFocused)
              .tint(.primary)
              .textEditorStyle(.automatic)
              .frame(maxWidth: .infinity)
              .frame(height: 120)
              .overlay(alignment: .topLeading) {
                if model.message.isEmpty {
                  Text("小さな偉業から始めよう...\n\n例: 起きれた、朝ごはんを食べた、ゴミを片付けた、忘れ物を届けた、食器洗った")
                    .allowsHitTesting(false)
                    .foregroundStyle(.secondary)
                    .padding(6)
                    .padding(.top, 2)
                }
              }
              .padding(16)
            
            if let image = model.selectedImage {
              Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .onTapGesture {
                  isFocused = false
                  environment.showImage = Image(uiImage: image)
                  environment.showViewer.toggle()
                }
            }
            
          } else {
            Text("未ログイン")
          }
        }
      }
      .scrollDismissesKeyboard(.immediately)
      .padding(16)
      .scrollContentBackground(.hidden)
      .background(Color(.baseBackGround))
      .safeAreaInset(edge: .bottom) {
        bottomActionsModule
      }
    }
    .onAppear {
      Task { @MainActor in
        isFocused = true
        shouldUpdate = false
      }
    }
    .onDisappear {
      model.showSuccess = false
    }
    .overlay {
      if model.showSuccess {
        LottieView(showSuccess: $model.showSuccess, name: "success_animation")
          .frame(height: 300)
          .onTapGesture {
            model.showSuccess = false
          }
      }
      if model.showFailure {
        LottieView(showSuccess: $model.showFailure, name: "failure_animation")
          .frame(width: 100, height: 100)
          .onTapGesture {
            model.showFailure = false
          }
      }
    }
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
    .confirmationDialog("偉業写真を選択する", isPresented: $model.showPhotoSelect) {
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
  }
  var bottomActionsModule: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack {
        Text("カテゴリ: ")
        Spacer()
        
        NavigationLink {
          CategoryInputView(message: model.message, selectedCategory: $model.category)
        } label: {
          CategoryInputCell(category: model.category, isLarge: false)
        }
      }
      .padding(8)

      Divider()

      HStack {
        Button {
          isFocused.toggle()
        } label: {
          Image(systemName: isFocused ? "keyboard.chevron.compact.down" : "keyboard")
            .padding(4)
        }

        Spacer()

        Button {
          model.showPhotoSelect.toggle()
        } label: {
          Image(systemName: "photo.stack")
            .padding(4)
        }
      }
      .padding(.horizontal)

      Divider()

      HStack {
        Image(systemName: "sun.horizon.fill")
        Text("あなたの偉業をみんなが待っている")
          .font(.caption)

        Spacer()

        Button(action: {
          Task {
            if isAutoGenerateCategory, model.category == nil {
              model.category = await geminiModel.reason(userInput: model.message, categories: categories)
            }
            await model.didTapPostButton(user: environment.user)
            environment.user?.postCount += 1
            isFocused = false
            shouldUpdate = true
            dismiss()
          }
        }, label: {
          Text("投稿する")
            .fontWeight(.bold)
        })
        .disabled(model.message.isEmpty)
        .disabled(model.posting)
        .disabled(geminiModel.inProgress)
        .buttonStyle(.borderedProminent)
        .tint(.orange)
      }
      .padding(.horizontal)
      .padding(.bottom, 4)
      .padding(.top, 2)
    }
    .background(Color(.baseBackGround))

  }
}
