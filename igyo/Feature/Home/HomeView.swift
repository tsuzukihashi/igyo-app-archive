import SwiftUI
import ImageViewer
import ImageViewerRemote

struct HomeView: View {
  @EnvironmentObject var environment: AppEnvironment
  @State var dragWidth: CGFloat = 0
  private let maxWidth: CGFloat = 260

  var body: some View {
    TimelineView()
      .gesture(
        DragGesture()
          .onChanged({ value in
            if value.location.x >= (environment.paths.isEmpty ? 50 : 160) {
              dragWidth = min(maxWidth, value.translation.width)
            }
          })
          .onEnded({ value in
            if dragWidth >= (environment.paths.isEmpty ? 40 : 80) {
              environment.showMenu = true
            } else {
              environment.showMenu = false
            }
            dragWidth = 0
          })
      )
      .modifier(AlertModifier(alertType: $environment.alertType))
      .fullScreenCover(isPresented: $environment.showForceUpdate, content: {
        ForceUpdateView()
      })
      .overlay {
        if environment.nameChangeAnimation {
          LottieView(showSuccess: $environment.nameChangeAnimation, name: "name_change")
            .frame(height: 300)
            .onTapGesture {
              environment.nameChangeAnimation = false
            }
        }
      }
      .overlay(ImageViewerRemote(imageURL: $environment.showImageURL, viewerShown: $environment.showViewerURL))
      .overlay(ImageViewer(image: $environment.showImage, viewerShown: $environment.showViewer))
      .overlay(alignment: .leading) {
        ZStack(alignment: .leading) {
          Color.black.opacity(0.45)
            .ignoresSafeArea()
            .opacity(environment.showMenu ? 1 : 0)
            .onTapGesture {
              environment.showMenu = false
            }

          SideMenuView()
            .ignoresSafeArea()
            .frame(width: maxWidth)
            .offset(
              x: environment.showMenu ? 0 : dragWidth - maxWidth
            )
            .animation(.easeInOut, value: environment.showMenu)
        }
        .gesture(
          DragGesture()
            .onChanged({ value in
              dragWidth = min(maxWidth, value.translation.width)
            })
            .onEnded({ value in
              if value.translation.width <= 100 {
                environment.showMenu = false
              }
              dragWidth = 0
            })
        )
      }
  }
}

#Preview {
  HomeView()
}
