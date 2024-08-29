import SwiftUI

enum TutorialState: CaseIterable {
  case first
  case second
  case third
  case force

  var title: String {
    switch self {
    case .first:
      "ようこそ"
    case .second:
      "褒めよう"
    case .third:
      "守ろう"
    case .force:
      "投稿しよう"
    }
  }

  var description: String {
    switch self {
    case .first:
      "このアプリにあなたを否定する人は誰もいません"
    case .second:
      "あなたも誰かを褒めるところから始めてみましょう"
    case .third:
      "ふさわしくない投稿からこの世界を守りましょう"
    case .force:
      "あなたの偉業を周知させよう"
    }
  }

  var imageName: String {
    switch self {
    case .first:
      "post001"
    case .second:
      "post002"
    case .third:
      "post003"
    case .force:
      "post004"
    }
  }
}

struct TutorialView: View {
  @EnvironmentObject var environment: AppEnvironment
  @State var model: TutorialViewModel = .init()
  @State var currentIndex: Int = 0
  @State var tutorialState: TutorialState = .first

  var body: some View {
    VStack(spacing: 16) {
      TabView(selection: $tutorialState,
              content: {
        ForEach(TutorialState.allCases, id: \.title) { state in
          VStack(alignment: .leading, spacing: 32) {
            Text(state.title)
              .font(.title)
              .fontWeight(.semibold)

            Spacer()

            Image(state.imageName)
              .resizable()
              .scaledToFit()
              .clipShape(RoundedRectangle(cornerRadius: 8))
              .shadow(radius: 4, x: 4, y: 4)
              .frame(maxWidth: .infinity)
            HStack {
              Spacer()
              Text(state.description)
                .fontWeight(.light)
                .font(.caption)
              Spacer()
            }
            Spacer()
          }
          .padding()
          .tag(state)
        }
      })
      .tabViewStyle(.page(indexDisplayMode: .always))
      .toolbarBackground(.orange, for: .tabBar)

      buttonButton
    }
    .frame(maxHeight: .infinity, alignment: .top)
    .scrollContentBackground(.hidden)
    .background(Color(.baseBackGround))
    .toolbarBackground(Color(.baseBackGround), for: .navigationBar)
  }

  var buttonButton: some View {
    Button {
      switch tutorialState {
      case .first:
        tutorialState = .second
      case .second:
        tutorialState = .third
      case .third:
        tutorialState = .force
      case .force:
        environment.showTutorial.toggle()
      }
    } label: {
      Text(tutorialState == .force ? "はじめる" : "次へ")
        .font(.headline)
        .bold()
        .padding(.vertical, 4)
        .frame(maxWidth: .infinity)
    }
    .tint(.orange)
    .buttonStyle(.borderedProminent)
    .padding()
  }
}

#Preview {
  TutorialView()
}
