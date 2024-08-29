import TipKit

public struct TimelinePostButtonTips: Tip {
  public init() {}
  
  public var image: Image? {
    nil
  }
  public var title: Text {
    Text("偉業を投稿しよう")
  }
  public var message: Text? {
    Text("みんなが褒めてくれるよ！")
  }
}
