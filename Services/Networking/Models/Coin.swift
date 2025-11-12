import Foundation

// MARK: - Coin
struct Coin: Codable, Identifiable, Hashable {
  let id, symbol, name: String
  let image: String
  let currentPrice: Double
  let marketCap, marketCapRank: Int
  let fullyDilutedValuation: Double?
  let totalVolume, high24H, low24H: Double
  let priceChange24H, priceChangePercentage24H: Double
  let marketCapChange24H: Double
  let marketCapChangePercentage24H: Double
  let circulatingSupply, totalSupply, maxSupply: Double?
  let ath, athChangePercentage: Double
  let athDate: String
  let atl, atlChangePercentage: Double
  let atlDate: String
  let roi: Roi?
  let lastUpdated: String
  let priceChangePercentage24HInCurrency: Double?
}

// MARK: - Roi
struct Roi: Codable, Hashable {
  let times: Double
  let currency: String
  let percentage: Double
}