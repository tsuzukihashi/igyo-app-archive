import SwiftUI

struct StrokeText: View {
  let text: String
  let width: CGFloat
  let fontColor: Color
  let outlineColor: Color
  let isLarge: Bool

  var body: some View {
    ZStack{
      ZStack{
        Text(text).offset(x:  width, y:  width)
        Text(text).offset(x: -width, y: -width)
        Text(text).offset(x: -width, y:  width)
        Text(text).offset(x:  width, y: -width)
      }
      .foregroundColor(outlineColor)

      Text(text)
        .foregroundColor(fontColor)
    }
    .fontWeight(.semibold)
    .fontDesign(.rounded)
    .font(isLarge ? .body : .caption)
  }
}
