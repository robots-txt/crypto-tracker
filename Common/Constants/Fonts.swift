import SwiftUI

extension Font {
  static func appTitle() -> Font { .largeTitle.bold() }
  static func headline() -> Font { .headline }
  static func subheadline() -> Font { .subheadline }
  static func body() -> Font { .body }
  static func caption() -> Font { .caption }
}

extension CGFloat {
  static let paddingSmall: CGFloat = 8
  static let paddingMedium: CGFloat = 16
  static let paddingLarge: CGFloat = 24
  static let cornerRadius: CGFloat = 10
  static let iconSize: CGFloat = 24
}