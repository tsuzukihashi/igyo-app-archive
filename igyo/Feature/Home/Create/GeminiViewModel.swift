import GoogleGenerativeAI
import SwiftUI

@Observable
class GeminiViewModel: ObservableObject {
  var errorMessage: String?
  var inProgress = false

  private var model: GenerativeModel?

  init() {
    model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
  }

  func reset() {
    errorMessage = nil
    inProgress = false
  }

  func reason(userInput: String, categories: [CachedCategory]) async -> Category? {
    defer {
      inProgress = false
    }
    guard let model else { return nil }

    inProgress = true
    errorMessage = nil

    let categoriesStr = categories.map { $0.title }.joined(separator: ", ")

    let prompt = "次に続く文章は \(categoriesStr) のどのカテゴリ分類されるか答えてください。: \(userInput)"
    var output: String = ""
    do {
      let outputContentStream = model.generateContentStream(prompt)
      for try await outputContent in outputContentStream {
        guard let line = outputContent.text else {
          return nil
        }

        output = output + line
      }
      return categories.first(where: { $0.title == output })?.convert()
    } catch {
      print("\(error.localizedDescription)")
      errorMessage = error.localizedDescription
      return nil
    }
  }
}
