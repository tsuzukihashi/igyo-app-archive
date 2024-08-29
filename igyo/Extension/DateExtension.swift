import Foundation

public enum DateStyle {
  case remaining(toFuture: Date)
  case difference(to: Date)
  case mmdd
  case mdhhmm
  case yyyyMMddHHmm
  case yyyyMM
  case yyyyMMdd
  case yyyyMMddEEEHHmm
  case yyyyMMddHHmmss
  case ult
  case mmddShort
}

public extension Date {
  func string(for style: DateStyle, timeZone: TimeZone? = nil) -> String {
    switch style {
    case .remaining(let toDate):
      let diff = toDate.timeIntervalSince(self)
      if diff <= 0 {
        return "終了"
      } else if diff <= 60 {
        let sec = Int(diff)
        return "残り" + String(sec) + "秒"
      } else if diff <= 3600 {
        let min = Int(diff / 60)
        return "残り" + String(min) + "分"
      } else if diff <= 86400 {
        let hour = Int(diff / 3600)
        return "残り" + String(hour) + "時間"
      } else {
        return mdhhmmFormatter(timeZone: timeZone).string(from: self)
      }
    case .difference(let toDate):
      let diff = toDate.timeIntervalSince(self)
      if diff <= 60 {
        return "たった今"
      } else if diff <= 3600 {
        let min = Int(diff / 60)
        return String(min) + "分前"
      } else if diff <= 3600 * 24 {
        let hour = Int(diff / 3600)
        return String(hour) + "時間前"
      } else {
        return mdhhmmFormatter(timeZone: timeZone).string(from: self)
      }
    case .mmdd:
      return mmddFormatter(timeZone: timeZone).string(from: self)
    case .mdhhmm:
      return mdhhmmFormatter(timeZone: timeZone).string(from: self)
    case .yyyyMMddHHmm:
      return yyyyMMddHHmmFormatter(timeZone: timeZone).string(from: self)
    case .yyyyMM:
      return yyyyMMFormatter(timeZone: timeZone).string(from: self)
    case .yyyyMMdd:
      return yyyyMMddFormatter(timeZone: timeZone).string(from: self)
    case .yyyyMMddEEEHHmm:
      return yyyyMMddEEEHHmmFormatter(timeZone: timeZone).string(from: self)
    case .yyyyMMddHHmmss:
      return yyyyMMddHHmmssFormatter(timeZone: timeZone).string(from: self)
    case .ult:
      return ultDateFormatter(timeZone: timeZone).string(from: self)
    case .mmddShort:
      return mmddShortFormatter(timeZone: timeZone).string(from: self)
    }
  }

  private func mmddFormatter(timeZone: TimeZone? = nil) -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "M月d日"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = timeZone
    return formatter
  }

  private func mdhhmmFormatter(timeZone: TimeZone? = nil) -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "M月d日 HH:mm"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = timeZone
    return formatter
  }

  private func yyyyMMddHHmmFormatter(timeZone: TimeZone? = nil) -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy年M月d日 HH:mm"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = timeZone
    return formatter
  }

  private func yyyyMMFormatter(timeZone: TimeZone? = nil) -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy年M月"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = timeZone
    return formatter
  }

  private func yyyyMMddFormatter(timeZone: TimeZone? = nil) -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy年M月d日"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = timeZone
    return formatter
  }

  private func yyyyMMddEEEHHmmFormatter(timeZone: TimeZone? = nil) -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy年M月d日（EEE）HH時mm分"
    formatter.locale = Locale(identifier: "ja_JP")
    formatter.timeZone = timeZone
    return formatter
  }

  private func ultDateFormatter(timeZone: TimeZone? = nil) -> DateFormatter {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US")
    formatter.dateFormat = "yyyy-MM-dd'T'HH-mm-ss+09-00"
    formatter.timeZone = timeZone
    return formatter
  }

  private func mmddShortFormatter(timeZone: TimeZone? = nil) -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "M/d"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = timeZone
    return formatter
  }

  private func yyyyMMddHHmmssFormatter(timeZone: TimeZone? = nil) -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMddHHmmss"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = timeZone
    return formatter
  }
}

public extension Date {
  func offsetFrom(date: Date = Date()) -> String {
    if yearsFrom(future: date) > 0 { return String(yearsFrom(future: date)) + "年前" }
    if monthsFrom(future: date) > 0 { return String(monthsFrom(future: date)) + "ヶ月前" }
    if weeksFrom(future: date) > 0 { return String(weeksFrom(future: date)) + "週間前" }
    if daysFrom(future: date) > 0 { return String(daysFrom(future: date)) + "日前" }
    if hoursFrom(future: date) > 0 { return String(hoursFrom(future: date)) + "時間前" }
    if minutesFrom(future: date) > 0 { return String(minutesFrom(future: date)) + "分前" }
    if secondsFrom(future: date) > 0 { return String(secondsFrom(future: date)) + "秒前" }
    return self.string(for: .mdhhmm)
  }

  func offsetTo(date: Date = Date()) -> String {
    if date.yearsFrom(future: self) > 0 { return "残り" + String(date.yearsFrom(future: self)) + "年" }
    if date.monthsFrom(future: self) > 0 { return "残り" + String(date.monthsFrom(future: self)) + "ヶ月" }
    if date.weeksFrom(future: self) > 0 { return "残り" + String(date.weeksFrom(future: self)) + "週間" }
    if date.daysFrom(future: self) > 0 { return "残り" + String(date.daysFrom(future: self)) + "日" }
    if date.hoursFrom(future: self) > 0 { return "残り" + String(date.hoursFrom(future: self)) + "時間" }
    if date.minutesFrom(future: self) > 0 { return "残り" + String(date.minutesFrom(future: self)) + "分" }
    if date.secondsFrom(future: self) > 0 { return "残り" + String(date.secondsFrom(future: self)) + "秒" }
    return ""
  }

  func yearsFrom(future: Date) -> Int {
    return Calendar.current.dateComponents([.year], from: self, to: future).year ?? 0
  }
  func monthsFrom(future: Date) -> Int {
    return Calendar.current.dateComponents([.month], from: self, to: future).month ?? 0
  }
  func weeksFrom(future: Date) -> Int {
    return Calendar.current.dateComponents([.weekOfYear], from: self, to: future).weekOfYear ?? 0
  }
  func daysFrom(future: Date) -> Int {
    return Calendar.current.dateComponents([.day], from: self, to: future).day ?? 0
  }
  func hoursFrom(future: Date) -> Int {
    return Calendar.current.dateComponents([.hour], from: self, to: future).hour ?? 0
  }
  func minutesFrom(future: Date) -> Int {
    return Calendar.current.dateComponents([.minute], from: self, to: future).minute ?? 0
  }
  func secondsFrom(future: Date) -> Int {
    return Calendar.current.dateComponents([.second], from: self, to: future).second ?? 0
  }
}
