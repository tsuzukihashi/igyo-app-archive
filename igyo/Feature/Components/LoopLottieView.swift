import Lottie
import SwiftUI

struct LoopLottieView: UIViewRepresentable {
  var name: String

  var animationView = LottieAnimationView()

  func makeUIView(context: UIViewRepresentableContext<LoopLottieView>) -> UIView {
    let view = UIView(frame: .zero)
    // 表示したいアニメーションのファイル名
    animationView.animation = LottieAnimation.named(name)
    // 比率
    animationView.contentMode = .scaleAspectFit
    // ループモード
    animationView.loopMode = .loop

    animationView.play()

    animationView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(animationView)
    NSLayoutConstraint.activate([
      animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
      animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
    ])
    return view
  }

  func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LoopLottieView>) {
  }
}
