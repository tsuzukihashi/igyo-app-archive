import SwiftUI
import AnimatedImage
import AnimatedImageSwiftUI

struct ReactionView: View {
  var type: ActionType
  var size: CGSize = .init(width: 24, height: 24)

  var body: some View {
    if let data = NSDataAsset(name: type.imageName)?.data {
      AnimatedImagePlayer(image: GifImage(data: data))
        .frame(width: 24, height: 24)
    } else {
      Text(type.rawValue)
        .font(.caption)
        .frame(width: 24, height: 24)
    }
  }
}

#Preview {
  ReactionView(type: .igyo)
}
