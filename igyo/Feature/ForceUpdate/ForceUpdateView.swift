import SwiftUI

struct ForceUpdateView: View {
  @EnvironmentObject var appEnvironment: AppEnvironment

  var body: some View {
    VStack {
      Image("force-update")
        .resizable()
        .scaledToFit()
        .frame(width: 120, height: 120)
      Text("ForceUpdate")

      if let storeURL = appEnvironment.storeURL {
        Button {
          UIApplication.shared.open(storeURL)
        } label: {
          Text("アップデートする")
        }

      }
    }
  }
}

#Preview {
  ForceUpdateView()
}
