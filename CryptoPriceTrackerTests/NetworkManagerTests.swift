import XCTest
@testable import CryptoPriceTracker

class NetworkManagerTests: XCTestCase {
  var networkManager: NetworkManager!
  var cache: URLCache!

  override func setUpWithError() throws {
    let configuration = URLSessionConfiguration.default
    configuration.protocolClasses = [MockURLProtocol.self]
    let session = URLSession(configuration: configuration)
    cache = URLCache(memoryCapacity: 50 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: nil) // In-memory cache for tests
    networkManager = NetworkManager(session: session, cache: cache)
  }

  override func tearDownWithError() throws {
    networkManager = nil
    cache.removeAllCachedResponses()
    cache = nil
    MockURLProtocol.requestHandler = nil
  }

  func test_request_success() async throws {
    // Given
    let mockCoins = [Coin.mock]
    let mockData = try JSONEncoder().encode(mockCoins)
    let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd")!

    MockURLProtocol.requestHandler = { request in
      let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
      return (response, mockData)
    }

    // When
    let coins: [Coin] = try await networkManager.request(url: url, forceRefresh: false)

    // Then
    XCTAssertEqual(coins.count, 1)
    XCTAssertEqual(coins.first?.id, "bitcoin")
  }

  func test_request_usesCacheOnSecondRequest() async throws {
    // Given
    let mockCoins1 = [Coin.mock]
    let mockData1 = try JSONEncoder().encode(mockCoins1)
    let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd")!
    let request = URLRequest(url: url)

    // 1. First request: populate cache
    MockURLProtocol.requestHandler = { request in
      let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
      // Manually store the response in the cache for the test
      let cachedResponse = CachedURLResponse(response: response, data: mockData1)
      self.cache.storeCachedResponse(cachedResponse, for: request)
      return (response, mockData1)
    }
    let _ = try await networkManager.request(url: url, forceRefresh: false) as [Coin]

    // When
    let cachedResponse = cache.cachedResponse(for: request)

    // Then
    XCTAssertNotNil(cachedResponse)
    let cachedCoins = try JSONDecoder().decode([Coin].self, from: cachedResponse!.data)
    XCTAssertEqual(cachedCoins.count, 1)
    XCTAssertEqual(cachedCoins.first?.id, "bitcoin")
  }

  func test_request_forceRefreshSkipsCache() async throws {
    // Given
    let mockCoins1 = [Coin.mock]
    let mockData1 = try JSONEncoder().encode(mockCoins1)
    let mockCoins2 = [Coin.mock2]
    let mockData2 = try JSONEncoder().encode(mockCoins2)
    let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd")!

    // 1. First request: populate cache with mockCoins1
    MockURLProtocol.requestHandler = { request in
      let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
      return (response, mockData1)
    }
    let _ = try await networkManager.request(url: url, forceRefresh: false) as [Coin]

    // 2. Second request: force refresh, mock network to return mockCoins2
    MockURLProtocol.requestHandler = { request in
      let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
      return (response, mockData2)
    }

    // When
    let coins: [Coin] = try await networkManager.request(url: url, forceRefresh: true)

    // Then
    XCTAssertEqual(coins.count, 1)
    XCTAssertEqual(coins.first?.id, "ethereum") // Expecting mockCoins2
  }

  func test_request_failure_badResponse() async {
    // Given
    let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd")!
    MockURLProtocol.requestHandler = { request in
      let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)!
      return (response, nil)
    }

    // When
    do {
      let _: [Coin] = try await networkManager.request(url: url, forceRefresh: false)
      XCTFail("Expected to throw an error, but did not.")
    } catch {
      // Then
      guard let networkError = error as? NetworkError else {
        XCTFail("Caught error was not a NetworkError")
        return
      }
      XCTAssertEqual(networkError, .invalidResponse)
    }
  }
  
  func test_request_failure_invalidURL() async {
    // When
    do {
      let _: [Coin] = try await networkManager.request(url: nil, forceRefresh: false)
      XCTFail("Expected to throw an error, but did not.")
    } catch {
      // Then
      guard let networkError = error as? NetworkError else {
        XCTFail("Caught error was not a NetworkError")
        return
      }
      XCTAssertEqual(networkError, .invalidURL)
    }
  }
}
