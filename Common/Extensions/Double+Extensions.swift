
import Foundation

extension Double {
  /// Formats a Double into a currency string with abbreviations for millions, billions, and trillions.
  /// ```
  /// Convert 1234567890 to $1.23B
  /// Convert 123456 to $123.45K
  /// Convert 1234 to $1.23K
  /// ```
  var formattedWithAbbreviations: String {
    let num = abs(Double(self))
    let sign = (self < 0) ? "-" : ""

    switch num {
    case 1_000_000_000_000...:
      let formatted = num / 1_000_000_000_000
      return "\(sign)\(String(format: "%.2f", formatted))T"
    case 1_000_000_000...:
      let formatted = num / 1_000_000_000
      return "\(sign)\(String(format: "%.2f", formatted))B"
    case 1_000_000...:
      let formatted = num / 1_000_000
      return "\(sign)\(String(format: "%.2f", formatted))M"
    case 1_000...:
      let formatted = num / 1_000
      return "\(sign)\(String(format: "%.2f", formatted))K"
    case 0...:
      return "\(sign)\(String(format: "%.2f", self))"
    default:
      return "\(sign)\(String(format: "%.2f", self))"
    }
  }
}
