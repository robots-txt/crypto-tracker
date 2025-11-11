import Foundation

@MainActor
class HomeViewModel: ObservableObject {
  @Published var coins: [Coin] = []
  @Published var errorMessage: String? = nil
  @Published var isLoading: Bool = false

  private let networkManager: NetworkManaging

  init(networkManager: NetworkManaging = NetworkManager()) {
    self.networkManager = networkManager
  }

  func fetchCoins(forceRefresh: Bool = false) async {
    isLoading = true
    errorMessage = nil
    do {
      coins = try await networkManager.request(url: CoinGeckoAPI.getCoinsMarketURL(), forceRefresh: forceRefresh)
    } catch {
      errorMessage = Strings.errorMessage
    }
    isLoading = false
  }
}
