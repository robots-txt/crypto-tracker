import SwiftUI

struct ContentView: View {
  @StateObject var viewModel = HomeViewModel()

  var body: some View {
    NavigationView {
      VStack {
        if viewModel.isLoading {
          ProgressView()
        } else if let errorMessage = viewModel.errorMessage {
          Text(errorMessage)
            .foregroundColor(.themeRed)
            .font(.headline())
          Button(Strings.retry) {
            Task { await viewModel.fetchCoins() }
          }
        } else {
          List(viewModel.coins) {
            coin in
            VStack(alignment: .leading) {
              Text(coin.name)
                .font(.headline())
                .foregroundColor(.themeText)
              Text(coin.symbol.uppercased())
                .font(.subheadline())
                .foregroundColor(.themeAccent)
              HStack {
                Text("\(coin.currentPrice, specifier: "%.2f")")
                  .font(.body())
                  .foregroundColor(.themeText)
                Spacer()
                Text("\(coin.priceChangePercentage24H, specifier: "%.2f")%")
                  .font(.body())
                  .foregroundColor(coin.priceChangePercentage24H >= 0 ? .themeGreen : .themeRed)
              }
              Text("Market Cap: \(coin.marketCap)")
                .font(.caption())
                .foregroundColor(.themeText)
            }
          }
          .refreshable {
            await viewModel.fetchCoins()
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