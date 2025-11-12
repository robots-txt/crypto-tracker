
import Foundation

extension Double {
  /// Converts a Double into a percentage String with 2 decimal places.
  /// ```
  /// Convert 0.25 to "25.00%"
  /// ```
  func asPercentWith2Decimals() -> String {
    let number = NSNumber(value: self)
    return Self.percentFormatter2.string(from: number) ?? "0.00%"
  }

  private static let percentFormatter2: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    formatter.multiplier = 1 // API already returns percentage, not fraction
    return formatter
  }()

  /// Converts a Double into a currency String with 2 decimal places.
  /// ```
  /// Convert 1234.56 to "$1,234.56"
  /// ```
  func asCurrencyWith2Decimals() -> String {
    let number = NSNumber(value: self)
    return Self.currencyFormatter2.string(from: number) ?? "$0.00"
  }

  private static let currencyFormatter2: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.usesGroupingSeparator = true
    formatter.numberStyle = .currency
    formatter.locale = .current // default is .current, but good to be explicit
    formatter.currencyCode = "usd" // change currency
    formatter.currencySymbol = "$" // change currency symbol
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    return formatter
  }()

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

extension String {
  /// Converts an ISO8601 date string to a formatted date string (d-MMM-yyyy hh:mm a).
  /// Returns the original string if parsing fails.
  var asFormattedDateString: String {
    if let date = Self.iso8601Formatter.date(from: self) {
      return Self.displayDateFormatter.string(from: date)
    }
    return self // Return original string if parsing fails
  }

  private static let iso8601Formatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter
  }()

  private static let displayDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d-MMM-yyyy hh:mm a"
    return formatter
  }()
}
