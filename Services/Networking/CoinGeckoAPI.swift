import Foundation

enum CoinGeckoAPI {
  static let baseURL = "https://api.coingecko.com/api/v3"

  enum Endpoints {
    static let coinsMarket = "/coins/markets"
  }

  static func getCoinsMarketURL(currency: String = "usd", order: String = "market_cap_desc", perPage: Int = 5, page: Int = 1, sparkline: Bool = false) -> URL? {
    var components = URLComponents(string: baseURL + Endpoints.coinsMarket)
    components?.queryItems = [
      URLQueryItem(name: "vs_currency", value: currency),
      URLQueryItem(name: "order", value: order),
      URLQueryItem(name: "per_page", value: String(perPage)),
      URLQueryItem(name: "page", value: String(page)),
      URLQueryItem(name: "sparkline", value: String(sparkline))
    ]
    return components?.url
  }
}