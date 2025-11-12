import SwiftUI

@MainActor
class Router: ObservableObject {
  @Published var path = NavigationPath()

  func navigate(to destination: Route) {
    path.append(destination)
  }

  func navigateBack() {
    path.removeLast()
  }

  func navigateToRoot() {
    path.removeLast(path.count)
  }
}
