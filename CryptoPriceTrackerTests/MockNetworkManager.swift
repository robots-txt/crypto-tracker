import Foundation
@testable import CryptoPriceTracker

class MockNetworkManager: NetworkManaging {
  var result: Result<[Coin], Error>?

  func request<T>(url: URL?, forceRefresh: Bool) async throws -> T where T : Decodable {
    switch result {
    case .success(let coins):
      return coins as! T
    case .failure(let error):
      throw error
    case .none:
      fatalError("Mock result not set")
    }
  }
}
