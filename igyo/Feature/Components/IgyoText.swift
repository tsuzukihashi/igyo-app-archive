import SwiftUI

struct IgyoText: View {
  var text: String

  var body: some View {
    Text(getAttribute(inputText: text))
      .fontWeight(.medium)
  }

  private func getAttribute(inputText: String) -> AttributedString {
    let urlPattern: String = "https?://[A-Za-z0-9-._~:/?#\\[\\]@!$&'()*+,;%=]+"
    let urls: [URL?] = inputText.matchAll(urlPattern).map { URL(string: String(inputText[$0])) }
    var attributedText = AttributedString(inputText)
    let ranges: [Range<AttributedString.Index>] = attributedText.matchAll(urlPattern)
    for case (let range, let url?) in zip(ranges, urls) {
      attributedText[range].link = url
    }

    return attributedText
  }
}

#Preview {
  IgyoText(text: "hoge")
}

extension AttributedStringProtocol {
  func match(_ pattern: String, options: String.CompareOptions? = nil) -> Range<AttributedString.Index>? {
    let options = options?.union(.regularExpression) ?? .regularExpression
    return self.range(of: pattern, options: options)
  }

  func matchAll(_ pattern: String, options: String.CompareOptions? = nil) -> [Range<AttributedString.Index>] {
    guard let range = match(pattern, options: options) else {
      return []
    }
    let remaining = self[range.upperBound...]
    return [range] + remaining.matchAll(pattern, options: options)
  }

  func contains(pattern: String, options: String.CompareOptions? = nil) -> Bool {
    match(pattern, options: options) != nil
  }
}

struct RegularExpression {
  let pattern: String
  let options: String.CompareOptions

  init(_ pattern: String, options: String.CompareOptions? = nil) {
    self.pattern = pattern
    self.options = options?.union(.regularExpression) ?? .regularExpression
  }

  func matchAll<T: StringProtocol>(_ input: T) -> [Range<T.Index>] {
    guard let range = input.range(of: pattern, options: options) else {
      return []
    }
    let remaining = input[range.upperBound...]
    return [range] + matchAll(remaining)
  }

  @available(iOS 15, *)
  func matchAll<T: AttributedStringProtocol>(_ input: T) -> [Range<AttributedString.Index>] {
    guard let range = input.range(of: pattern, options: options) else {
      return []
    }
    let remaining = input[range.upperBound...]
    return [range] + matchAll(remaining)
  }
}

extension StringProtocol {
  func match(_ pattern: String, options: String.CompareOptions? = nil) -> Range<Index>? {
    let options = options?.union(.regularExpression) ?? .regularExpression
    return self.range(of: pattern, options: options)
  }

  func matchAll(_ pattern: String, options: String.CompareOptions? = nil) -> [Range<Index>] {
    guard let range = match(pattern, options: options) else {
      return []
    }
    let remaining = self[range.upperBound...]
    return [range] + remaining.matchAll(pattern, options: options)
  }

  func contains(pattern: String, options: String.CompareOptions? = nil) -> Bool {
    match(pattern, options: options) != nil
  }
}
