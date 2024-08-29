import SwiftUI

struct PageControllView: UIViewRepresentable {
  @Binding var currentPage: Int
  var numberOfPages: Int = 0

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  func makeUIView(context: Context) -> UIPageControl {
    let pageControl = UIPageControl()
    pageControl.currentPageIndicatorTintColor = .label
    pageControl.numberOfPages = numberOfPages
    pageControl.pageIndicatorTintColor = .secondaryLabel
    pageControl.addTarget(
      context.coordinator,
      action: #selector(Coordinator.updateCurrentPage(sender:)),
      for: .valueChanged
    )
    return pageControl
  }

  func updateUIView(_ uiView: UIPageControl, context: Context) {
    uiView.currentPage = currentPage
  }

  class Coordinator: NSObject {
    var pageControl: PageControllView

    init(_ pageControl: PageControllView) {
      self.pageControl = pageControl
    }

    @objc func updateCurrentPage(sender: UIPageControl) {
      pageControl.currentPage = sender.currentPage
    }
  }
}
