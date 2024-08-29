import SwiftUI

struct ReportListView: View {
  @State var model: ReportListViewModel = .init(
    useCase: ReportUseCase(reportService: ReportService())
  )
  @EnvironmentObject var environment: AppEnvironment

  var body: some View {
    List {
      ForEach(model.reports) { report in
        VStack(spacing: 16) {
          VStack(alignment: .leading) {
            HStack {
              Text(report.postUserName)
              Spacer()
              Text(report.createdAt.string(for: .yyyyMMddEEEHHmm))
            }
            .font(.caption)

            Text(report.postMessage)

            Text("申告理由: \(report.reportType.title)")
              .font(.caption)
          }
          HStack {
            Image(.forceUpdate)
              .resizable()
              .scaledToFit()
              .frame(width: 52, height: 52)
            VStack(alignment: .leading) {
              Text("開発者: " + (report.checked ? "確認済み" : "未確認"))
              Text(report.answer)
            }
            .font(.caption)
            Spacer()
          }
        }
      }
    }
    .navigationTitle("報告した違反申告リスト")
    .navigationBarTitleDisplayMode(.inline)
    .overlay {
      if model.reports.isEmpty {
        ContentUnavailableView.init("報告した違反はありません", systemImage: "exclamationmark.bubble")
      }
    }
    .task {
      await model.onAppear(userID: environment.user?.id)
    }
    .scrollContentBackground(.hidden)
    .background(Color(.baseBackGround))
    .toolbarBackground(Color(.baseBackGround), for: .navigationBar)
  }
}

#Preview {
  ReportListView()
}
