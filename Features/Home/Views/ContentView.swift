import SwiftUI

struct ContentView: View {
  @StateObject var viewModel = HomeViewModel()

  var body: some View {
    NavigationView {
      Group {
        if viewModel.isLoading {
          ProgressView()
        } else if let errorMessage = viewModel.errorMessage {
          VStack {
            Text(errorMessage)
              .foregroundColor(.themeRed)
              .font(.headline())
            Button(Strings.retry) {
              Task { await viewModel.fetchCoins() }
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
      Task { await viewModel.fetchCoins() }
    }
  }
}

#Preview {
  ContentView()
}
