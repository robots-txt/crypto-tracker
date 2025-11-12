import XCTest
import Combine
@testable import CryptoPriceTracker

@MainActor
final class HomeViewModelTests: XCTestCase {
  var viewModel: HomeViewModel!
  var mockNetworkManager: MockNetworkManager!
  private var cancellables = Set<AnyCancellable>()

  override func setUpWithError() throws {
    mockNetworkManager = MockNetworkManager()
    viewModel = HomeViewModel(networkManager: mockNetworkManager)
  }

  override func tearDownWithError() throws {
    viewModel = nil
    mockNetworkManager = nil
    cancellables.removeAll()
  }

  func test_fetchCoins_success() async throws {
    // Given
    let mockCoins = [Coin(id: "bitcoin", symbol: "btc", name: "Bitcoin", image: "", currentPrice: 10000, marketCap: 1000000000, marketCapRank: 1, fullyDilutedValuation: nil, totalVolume: 1000000, high24H: 10500, low24H: 9500, priceChange24H: 100, priceChangePercentage24H: 1.0, marketCapChange24H: 10000000, marketCapChangePercentage24H: 1.0, circulatingSupply: nil, totalSupply: nil, maxSupply: nil, ath: 11000, athChangePercentage: 10, athDate: "", atl: 9000, atlChangePercentage: 10, atlDate: "", roi: nil, lastUpdated: "", priceChangePercentage24HInCurrency: nil)]
    mockNetworkManager.result = .success(mockCoins)

    // When
    await viewModel.fetchCoins()

    // Then
    XCTAssertFalse(viewModel.isLoading)
    XCTAssertNil(viewModel.errorMessage)
    XCTAssertEqual(viewModel.coins.count, 1)
    XCTAssertEqual(viewModel.coins.first?.id, "bitcoin")
  }

  func test_initialState() {
    // Then
    XCTAssertTrue(viewModel.coins.isEmpty)
    XCTAssertFalse(viewModel.isLoading)
    XCTAssertNil(viewModel.errorMessage)
  }

  func test_loadingState() async {
    // Given
    let expectation = XCTestExpectation(description: "isLoading should be true")
    let mockCoins = [Coin(id: "bitcoin", symbol: "btc", name: "Bitcoin", image: "", currentPrice: 10000, marketCap: 1000000000, marketCapRank: 1, fullyDilutedValuation: nil, totalVolume: 1000000, high24H: 10500, low24H: 9500, priceChange24H: 100, priceChangePercentage24H: 1.0, marketCapChange24H: 10000000, marketCapChangePercentage24H: 1.0, circulatingSupply: nil, totalSupply: nil, maxSupply: nil, ath: 11000, athChangePercentage: 10, athDate: "", atl: 9000, atlChangePercentage: 10, atlDate: "", roi: nil, lastUpdated: "", priceChangePercentage24HInCurrency: nil)]
    mockNetworkManager.result = .success(mockCoins)
    
    viewModel.$isLoading
      .sink { isLoading in
        if isLoading {
          expectation.fulfill()
        }
      }
      .store(in: &cancellables)

    // When
    let task = Task {
      await viewModel.fetchCoins()
    }
    
    // Then
    await fulfillment(of: [expectation], timeout: 1.0)
    await task.value
    XCTAssertFalse(viewModel.isLoading)
  }

  func test_fetchCoins_success_emptyResponse() async throws {
    // Given
    mockNetworkManager.result = .success([])

    // When
    await viewModel.fetchCoins()

    // Then
    XCTAssertFalse(viewModel.isLoading)
    XCTAssertNil(viewModel.errorMessage)
    XCTAssertTrue(viewModel.coins.isEmpty)
  }

  func test_fetchCoins_failure_invalidURL() async throws {
    // Given
    mockNetworkManager.result = .failure(NetworkError.invalidURL)

    // When
    await viewModel.fetchCoins()

    // Then
    XCTAssertFalse(viewModel.isLoading)
    XCTAssertNotNil(viewModel.errorMessage)
    XCTAssertTrue(viewModel.coins.isEmpty)
  }

  func test_fetchCoins_failure() async throws {
    // Given
    let mockError = NetworkError.requestFailed(URLError(.badServerResponse))
    mockNetworkManager.result = .failure(mockError)

    // When
    await viewModel.fetchCoins()

    // Then
    XCTAssertFalse(viewModel.isLoading)
    XCTAssertNotNil(viewModel.errorMessage)
    XCTAssertTrue(viewModel.coins.isEmpty)
  }
}
