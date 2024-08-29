import SwiftUI

struct ActionsListView: View {
  var userID: String
  @State var model: ActionsListViewModel = .init(
    noticeUseCase: NoticeUseCase(
      noticeService: NoticeService()
    )
  )

  var body: some View {
    ScrollView {
      LazyVStack(spacing: 0) {
        ForEach(model.notices) { notice in
          NoticeActionsCell(notice: notice)
            .onAppear() {
              Task {
                await model.nextFetchIfNeeded(notice: notice)
              }
            }
        }
      }
      .padding(.horizontal, 4)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .task {
      await model.onAppear(userID: userID)
    }
    .background(Color(.baseBackGround))
    .toolbarBackground(Color(.baseBackGround), for: .navigationBar)
    .navigationTitle("アクションリスト")
  }
}

#Preview {
  ActionsListView(userID: "")
}
