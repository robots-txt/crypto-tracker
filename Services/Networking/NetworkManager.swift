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

    let (data, response): (Data, URLResponse)
    do {
      (data, response) = try await URLSession.shared.data(from: url)
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
        print("Failed to decode JSON. Raw response: \(jsonString)")
      }
      // Print the specific decoding error
      print("Decoding error: \(decodingError)")
      throw NetworkError.decodingFailed(decodingError)
    } catch {
      throw NetworkError.unknown
    }
  }
}