import SwiftUI

struct NoticeView: View {
  @State var model: NoticeViewModel = .init(
    useCase: NoticeUseCase(
      noticeService: NoticeService()
    )
  )
  @EnvironmentObject var environment: AppEnvironment

  var body: some View {
    ScrollView(showsIndicators: false) {
      LazyVStack {
        ForEach(model.notices) { notice in
          NoticeCell(notice: notice)
        }
      }
    }
    .refreshable {
      Task {
        await model.pullToRefresh(uid: environment.user?.id)
      }
    }
    .padding(.horizontal, 16)
    .navigationTitle("お知らせ")
    .toolbarBackground(Color(.baseBackGround), for: .navigationBar)
    .navigationBarTitleDisplayMode(.inline)
    .scrollContentBackground(.hidden)
    .background(Color(.baseBackGround))
    .task {
      await model.onAppear(uid: environment.user?.id)
    }
    .overlay {
      if model.notices.isEmpty {
        VStack {
          LoopLottieView(name: "empty")
            .frame(width: 200, height: 200)
          Text("お知らせはありません")
            .font(.headline)
        }
      }
    }

  }
}

#Preview {
  NoticeView()
}
