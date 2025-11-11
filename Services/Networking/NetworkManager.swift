import Foundation

enum NetworkError: Error {
  case invalidURL
  case requestFailed(Error)
  case invalidResponse
  case decodingFailed(Error)
  case unknown
}

protocol NetworkManaging {
  func request<T: Decodable>(url: URL?, forceRefresh: Bool) async throws -> T
}

class NetworkManager: NetworkManaging {
  private let session: URLSession

  init() {
    let configuration = URLSessionConfiguration.default
    configuration.requestCachePolicy = .returnCacheDataElseLoad
    configuration.urlCache = URLCache(
      memoryCapacity: 50 * 1024 * 1024, // 50 MB
      diskCapacity: 100 * 1024 * 1024, // 100 MB
      diskPath: "coin_cache"
    )
    self.session = URLSession(configuration: configuration)
  }

  func request<T: Decodable>(url: URL?, forceRefresh: Bool = false) async throws -> T {
    guard let url = url else {
      throw NetworkError.invalidURL
    }

    let request = URLRequest(url: url)

    if forceRefresh {
      dPrint("Forcing API fetch (pull to refresh), clearing cache for this request.")
      session.configuration.urlCache?.removeCachedResponse(for: request)
    } else {
      if let _ = session.configuration.urlCache?.cachedResponse(for: request) {
        dPrint("Loading from cache")
      } else {
        dPrint("Fetching from API (initial load)")
      }
    }

    let (data, response): (Data, URLResponse)
    do {
      (data, response) = try await session.data(for: request)
    } catch {
      throw NetworkError.requestFailed(error)
    }

    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
      throw NetworkError.invalidResponse
    }

    do {
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      return try decoder.decode(T.self, from: data)
    } catch let decodingError as DecodingError {
      // Print the raw JSON data for debugging
      if let jsonString = String(data: data, encoding: .utf8) {
        dPrint("Failed to decode JSON. Raw response: \(jsonString)")
      }
      // Print the specific decoding error
      dPrint("Decoding error: \(decodingError)")
      throw NetworkError.decodingFailed(decodingError)
    } catch {
      throw NetworkError.unknown
    }
  }
}
