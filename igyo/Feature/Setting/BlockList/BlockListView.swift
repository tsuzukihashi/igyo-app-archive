import SwiftUI

struct BlockListView: View {
  @EnvironmentObject var environment: AppEnvironment

    var body: some View {
      List {
        ForEach(environment.blockIDs, id: \.self) { id in
          NavigationLink(value: IgyoPath.userProfile(userID: id)) {
            Text(id)
          }
        }
      }
      .overlay {
        if environment.blockIDs.isEmpty {
          ContentUnavailableView.init("ブロックしたユーザーはいません", systemImage: "person.slash.fill")
        }
      }
      .listStyle(.grouped)
      .navigationTitle("ブロックしたユーザーリスト")
      .navigationBarTitleDisplayMode(.inline)
      .scrollContentBackground(.hidden)
      .background(Color(.baseBackGround))
      .toolbarBackground(Color(.baseBackGround), for: .navigationBar)
    }
}

#Preview {
    BlockListView()
}
