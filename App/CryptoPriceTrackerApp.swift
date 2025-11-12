import SwiftUI

@main
struct CryptoPriceTrackerApp: App {
  @StateObject private var router = Router()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(router)
    }
  }
}
