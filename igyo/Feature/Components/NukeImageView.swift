import SwiftUI
import NukeUI

struct NukeImageView: View {
  enum RenderType {
    case normal(size: CGFloat, cornerRadius: CGFloat)
    case rectangle(size: CGSize, cornerRadius: CGFloat)
    case slim(size: CGFloat, cornerRadius: CGFloat)
    case resizable
  }

  var urlStr: String
  var type: RenderType

  var body: some View {
    LazyImage(url: URL(string: urlStr)) { state in
      switch type {
      case .normal(let size, let cornerRadius):
        if let image = state.image {
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .cornerRadius(cornerRadius)
        } else if state.error != nil {
          Color.gray
            .frame(width: size, height: size)
            .cornerRadius(cornerRadius)
        } else {
          ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: cornerRadius)
              .frame(width: size, height: size, alignment: .center)
              .aspectRatio(1.0, contentMode: .fill)
              .foregroundColor(Color.secondary.opacity(0.4))
            ProgressView()
          }
        }
      case .slim(let size, let cornerRadius):
        if let image = state.image {
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size * 1.3)
            .cornerRadius(cornerRadius)
        } else if state.error != nil {
          Color.gray
            .frame(width: size, height: size * 1.3)
            .cornerRadius(cornerRadius)
        } else {
          ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: cornerRadius)
              .frame(width: size, height: size * 1.3)
              .aspectRatio(1.0, contentMode: .fill)
              .foregroundColor(Color.secondary.opacity(0.4))
            ProgressView()
          }
        }
      case .rectangle(let size, let cornerRadius):
        if let image = state.image {
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size.width, height: size.height)
            .cornerRadius(cornerRadius)
        } else if state.error != nil {
          Color.gray
            .frame(width: size.width, height: size.height)    
            .cornerRadius(cornerRadius)
        } else {
          ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: cornerRadius)
              .frame(width: size.width, height: size.height)
              .aspectRatio(1.0, contentMode: .fill)
              .foregroundColor(Color.secondary.opacity(0.4))
            ProgressView()
          }
        }
      case .resizable:
        switch state.result {
        case .success(let response):
          SwiftUI.Image(uiImage: response.image)
            .resizable()
            .scaledToFill()
        case .failure:
          Color.gray
        case .none:
          ZStack(alignment: .center) {
            Rectangle()
              .aspectRatio(1.0, contentMode: .fill)
              .foregroundColor(Color.secondary.opacity(0.4))
            ProgressView()
          }
        }
      }

    }
  }
}
