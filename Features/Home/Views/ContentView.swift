import SwiftUI

struct ContentView: View {
  @StateObject var viewModel: HomeViewModel

  // This initializer is for previews and dependency injection
  init(viewModel: HomeViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  // This initializer is for the main app target
  @MainActor
  init() {
    self.init(viewModel: HomeViewModel())
  }

  @Environment(\.isPreview) var isPreview
  
  var body: some View {
    NavigationView {
      Group {
        if viewModel.isLoading {
          ProgressView()
        } else if let errorMessage = viewModel.errorMessage {
          VStack {
            Text(errorMessage)
              .foregroundColor(.themeRed)
              .font(Font.headline())
            Button(Strings.retry) {
              Task { await viewModel.fetchCoins(forceRefresh: true) }
            }
          }
        } else {
          List(viewModel.coins) { coin in
            CoinRowView(coin: coin, isLast: coin.id == viewModel.coins.last?.id)
          }
          .listStyle(.plain)
          .refreshable {
            await viewModel.fetchCoins(forceRefresh: true)
          }
        }
      }
      .navigationTitle(Strings.cryptoTracker)
      .background(Color.themeBackground.ignoresSafeArea())
    }
    .onAppear {
      if !isPreview {
        Task { await viewModel.fetchCoins() }
      }
    }
  }
}

#Preview("Success") {
  let viewModel = HomeViewModel()
  viewModel.coins = [Coin.mock, Coin.mock2]
  return ContentView(viewModel: viewModel)
}

#Preview("Loading") {
  let viewModel = HomeViewModel()
  viewModel.isLoading = true
  return ContentView(viewModel: viewModel)
}

#Preview("Error") {
  let viewModel = HomeViewModel()
  viewModel.errorMessage = "Something went wrong. Please try again."
  return ContentView(viewModel: viewModel)
}
