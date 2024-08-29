import SwiftUI

struct HiddenListView: View {
  @EnvironmentObject var environment: AppEnvironment

  var body: some View {
    List {
      ForEach(environment.hiddenPostIDs, id: \.self) { id in
        NavigationLink(value: IgyoPath.userProfile(userID: id)) {
          Text(id)
        }
      }
    }
    .overlay {
      if environment.hiddenPostIDs.isEmpty {
        ContentUnavailableView.init("非表示にした投稿はありません", systemImage: "person.slash.fill")
      }
    }
    .listStyle(.grouped)
    .navigationTitle("非表示にした投稿リスト")
    .navigationBarTitleDisplayMode(.inline)
    .scrollContentBackground(.hidden)
    .background(Color(.baseBackGround))
    .toolbarBackground(Color(.baseBackGround), for: .navigationBar)
  }
}

#Preview {
    HiddenListView()
}
