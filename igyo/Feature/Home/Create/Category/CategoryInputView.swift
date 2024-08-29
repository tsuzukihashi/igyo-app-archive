import SwiftUI
import SwiftData

struct CategoryInputView: View {
  @AppStorage("isAutoGenerateCategory") var isAutoGenerateCategory: Bool = true
  @AppStorage("usedCategories") var usedCategories: [Int] = []
  @Query(sort: \CachedCategory.index) var categories: [CachedCategory] = []
  @State var geminiModel: GeminiViewModel = .init()
  @State var model: CategoryInputViewModel = .init(
    useCase: CategoryUseCase(
      service: CategoryService()
    )
  )
  @Environment(\.dismiss) var dismiss
  var message: String

  @Binding var selectedCategory: Category?

  var body: some View {
    ScrollView {
      LazyVStack(alignment: .leading, spacing: 32) {
        VStack(alignment: .leading) {
          Toggle(isOn: $isAutoGenerateCategory) {
            Text("AI自動生成")
          }
          Text("ONにしておくと今後自動的にカテゴリを生成して投稿に追加されるようになります。")
            .font(.caption)
            .foregroundStyle(.secondary)
        }

        selectedCategorySection

        if !usedCategories.isEmpty {
          usedCategorySection
        }

        allCategorySection
      }
      .padding(.horizontal, 8)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.baseBackGround))
    .toolbarBackground(Color(.baseBackGround), for: .navigationBar)
    .navigationTitle("カテゴリ")
    .task {
      await model.onAppear(categories: categories.map { $0.convert() })
    }
  }

  var selectedCategorySection: some View {
    VStack(alignment: .leading) {
      Text("選択中のカテゴリ:")
        .font(.caption)
        .fontWeight(.bold)
      HStack {
        Button {
          selectedCategory = nil
        } label: {
          CategoryInputCell(category: selectedCategory, isLarge: true)
        }
        .overlay(alignment: .topTrailing) {
          if selectedCategory != nil {
            Image(systemName: "xmark.circle.fill")
              .foregroundStyle(.white)
              .background(Circle().foregroundStyle(.black))
              .offset(x: 4, y: -8)
          }
        }

        if selectedCategory == nil {
          Button(action: {
            Task {
              selectedCategory = await geminiModel.reason(userInput: message, categories: categories)
            }
          }, label: {
            Text("AI自動生成")
              .padding(1)
          })
          .tint(.black)
          .buttonStyle(.borderedProminent)
          .disabled(message.isEmpty)
          .disabled(geminiModel.inProgress)
        }
      }
    }
  }

  var usedCategorySection: some View {
    LazyVStack(alignment: .leading) {
      Text("前回選択したカテゴリ")
        .font(.caption)
        .fontWeight(.bold)
      FlowLayout(alignment: .leading, spacing: 7) {
        ForEach(usedCategories, id: \.self) { id in
          if let category = categories.first(where: { $0.index == id })?.convert() {
            categoryButton(category: category)
          }
        }
      }
    }
  }

  var allCategorySection: some View {
    LazyVStack(alignment: .leading) {
      Text("すべてのカテゴリ")
        .font(.caption)
        .fontWeight(.bold)

      FlowLayout(alignment: .leading, spacing: 7) {
        ForEach(model.displayCategories, id: \.index) { category in
          categoryButton(category: category)
        }
      }
    }
  }

  func categoryButton(category: Category) -> some View {
    Button {
      selectedCategory = category

      usedCategories.removeAll(where: { $0 == category.index })
      usedCategories.insert(category.index, at: 0)
      if usedCategories.count >= 5 {
        usedCategories.removeLast()
      }

      dismiss()
    } label: {
      CategoryInputCell(category: category, isLarge: true)
    }
  }
}

#Preview {
  CategoryInputView(message: "", selectedCategory: .constant(.stub))
}
