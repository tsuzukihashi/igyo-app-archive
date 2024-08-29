import SwiftUI

struct CategoryInputCell: View {
  var category: Category?
  var isLarge: Bool

  var body: some View {
    ZStack {
      if let category {
        StrokeText(
          text: category.title,
          width: 0.3,
          fontColor: .white,
          outlineColor: .black,
          isLarge: isLarge
        )
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(
          RoundedRectangle(cornerRadius: 8)
            .foregroundStyle(Color(hex: category.code))
        )
      } else {
        Text("未選択")
          .font(isLarge ? .body : .caption)
          .padding(.vertical, 8)
          .padding(.horizontal, 16)
          .background(
            RoundedRectangle(cornerRadius: 8)
              .stroke(lineWidth: 1)
              .foregroundStyle(.secondary)

          )
      }
    }
  }
}

#Preview {
  CategoryInputCell(isLarge: true)
}
