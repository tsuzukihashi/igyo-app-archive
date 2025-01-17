import SwiftUI

public extension Color {
  init(
    hue: Double,
    saturation: Double,
    lightness: Double,
    opacity: Double = 1
  ) {
    let (h, s, b) = ColorTransformer.hslToHsb(h: hue, s: saturation, l: lightness)
    self = Color(hue: h, saturation: s, brightness: b, opacity: opacity)
  }

  init(hex: String, opacity: Double = 1.0) {
    let v = Int(hex, radix: 16) ?? 0
    let r = Double(v / Int(powf(256, 2)) % 256) / 255
    let g = Double(v / Int(powf(256, 1)) % 256) / 255
    let b = Double(v / Int(powf(256, 0)) % 256) / 255
    self = Color(red: r, green: g, blue: b, opacity: opacity)
  }

  func uiColor() -> UIColor {
    let (r, g, b, a) = getRGBA()
    return UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
  }

  func getRGBA() -> (r: Double, g: Double, b: Double, a: Double) {
    let str = String(self.description.dropFirst())
    let value = Int(str, radix: 16) ?? 0
    let r = Double(value / Int(powf(256, 3)) % 256) / 255
    let g = Double(value / Int(powf(256, 2)) % 256) / 255
    let b = Double(value / Int(powf(256, 1)) % 256) / 255
    let a = Double(value / Int(powf(256, 0)) % 256) / 255
    return (r, g, b, a)
  }

  func getHSLA() -> (h: Double, s: Double, l: Double, a: Double) {
    let (r, g, b, a) = getRGBA()
    let (h, s, l) = ColorTransformer.rgbToHsl(r: r, g: g, b: b)
    return (h, s, l, a)
  }

  func lighterColor() -> Color {
    let (h, s, l, a) = getHSLA()
    return Color(hue: h, saturation: s, lightness: min(l + 0.12, 1), opacity: a)
  }

  func darkerColor() -> Color {
    let (h, s, l, a) = getHSLA()
    return  Color(hue: h, saturation: s, lightness: max(l - 0.199, 0), opacity: a)
  }
}

internal enum ColorTransformer {
    static func hslToHsb(
        h: Double,
        s: Double,
        l: Double
    ) -> (h: Double, s: Double, b: Double) {
        let (r, g, b) = hslToRgb(h: h, s: s, l: l)
        return Self.rgbToHsb(r: r, g: g, b: b)
    }

    static func rgbToHsl(
        r: Double,
        g: Double,
        b: Double
    ) -> (h: Double, s: Double, l: Double) {
        let (r, g, b) = (r*255, g*255, b*255)

        let maxVal = max(r, g, b)
        let minVal = min(r, g, b)

        let h: Double = getHFromRGB(r: r, g: g, b: b)

        let s: Double = {
            let cnt = (maxVal + minVal) / 2
            if cnt < 128 {
                let a = (maxVal - minVal) / (maxVal + minVal)
                return a.isNaN ? 0 : a
            } else {
                let a = (maxVal - minVal) / (510 - maxVal - minVal)
                return a.isNaN ? 0 : a
            }
            }() * 255

        let l = (maxVal + minVal) / 2

        return (h/360, s/255, l/255)
    }

    static func hslToRgb(
        h: Double,
        s: Double,
        l: Double
    ) -> (r: Double, g: Double, b: Double) {
        let (h, s, l) = (h*360, s*100, l*100)

        let max: Double
        let min: Double
        if l <= 50 {
            max = 2.55 * (l + l * (s / 100))
            min = 2.55 * (l - l * (s / 100))
        } else {
            max = 2.55 * (l + (100 - l) * (s / 100))
            min = 2.55 * (l - (100 - l) * (s / 100))
        }

        let rgb: (Double, Double, Double)
        switch h {
        case 0...60:
            let g = (h / 60) * (max - min) + min
            rgb = (max, g, min)
        case 60...120:
            let r = ((120 - h) / 60) * (max - min) + min
            rgb = (r, max, min)
        case 120...180:
            let b = ((h - 120) / 60) * (max - min) + min
            rgb = (min, max, b)
        case 180...240:
            let g = ((240 - h) / 60) * (max - min) + min
            rgb = (min, g, max)
        case 240...300:
            let r = ((h - 240) / 60) * (max - min) + min
            rgb = (r, min, max)
        default:
            let b = ((360 - h) / 60) * (max - min) + min
            rgb = (max, min, b)
        }
        return (rgb.0 / 255, rgb.1 / 255, rgb.2 / 255)
    }

    static func rgbToHsb(
        r: Double,
        g: Double,
        b: Double
    ) -> (h: Double, s: Double, b: Double) {
        let (r, g, b) = (r*255, g*255, b*255)

        let maxVal = max(r, g, b)
        let minVal = min(r, g, b)

        let h = getHFromRGB(r: r, g: g, b: b)
        var s = (maxVal - minVal) / maxVal * 255
        if s.isNaN { s = 0 }
        return (h/360, s/255, maxVal/255)
    }

    private static func getHFromRGB(r: Double, g: Double, b: Double) -> Double {
        if r == g, g == b { return 0 }

        let maxVal = max(r, g, b)
        let minVal = min(r, g, b)

        func cal(_ x: Double, max: Double, min: Double) -> Double {
            return 60 * (x / (max - min))
        }

        var h: Double
        switch maxVal {
        case r:
            h = cal(g - b, max: maxVal, min: minVal)
            if h.isNaN { h = 0 }
        case g:
            h = cal(b - r, max: maxVal, min: minVal) + 120
            if h.isNaN { h = 120 }
        case b:
            h = cal(r - g, max: maxVal, min: minVal) + 240
            if h.isNaN { h = 240 }
        default: h = 0
        }
        return h >= 0 ? h : h + 360
    }
}
