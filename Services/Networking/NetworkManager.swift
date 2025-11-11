import Foundation

enum NetworkError: Error {
  case invalidURL
  case requestFailed(Error)
  case invalidResponse
  case decodingFailed(Error)
  case unknown
}

protocol NetworkManaging {
  func request<T: Decodable>(url: URL?) async throws -> T
}

class NetworkManager: NetworkManaging {
  func request<T: Decodable>(url: URL?) async throws -> T {
    guard let url = url else {
      throw NetworkError.invalidURL
    }

    do {
      let (data, response) = try await URLSession.shared.data(from: url)

      guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
        throw NetworkError.invalidResponse
      }

      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      return try decoder.decode(T.self, from: data)
    } catch let decodingError as DecodingError {
      throw NetworkError.decodingFailed(decodingError)
    } catch {
      throw NetworkError.requestFailed(error)
    }
  }
}