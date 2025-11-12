import Foundation

#if DEBUG
extension Coin {
  static var mock: Coin {
    Coin(
      id: "bitcoin",
      symbol: "btc",
      name: "Bitcoin",
      image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
      currentPrice: 65000.00,
      marketCap: 1200000000000,
      marketCapRank: 1,
      fullyDilutedValuation: 1300000000000,
      totalVolume: 50000000000,
      high24H: 66000.00,
      low24H: 64000.00,
      priceChange24H: 1000.00,
      priceChangePercentage24H: 1.5,
      marketCapChange24H: 20000000000,
      marketCapChangePercentage24H: 1.6,
      circulatingSupply: 19000000,
      totalSupply: 21000000,
      maxSupply: 21000000,
      ath: 69000.00,
      athChangePercentage: -5.8,
      athDate: "2021-11-10T14:24:11.849Z",
      atl: 67.81,
      atlChangePercentage: 95734.0,
      atlDate: "2013-07-06T00:00:00.000Z",
      roi: nil,
      lastUpdated: "2023-10-27T10:00:00.000Z",
      priceChangePercentage24HInCurrency: 1.5
    )
  }
  
  static var mock2: Coin {
      Coin(
          id: "ethereum",
          symbol: "eth",
          name: "Ethereum",
          image: "https://assets.coingecko.com/coins/images/279/large/ethereum.png?1595348880",
          currentPrice: 2200.00,
          marketCap: 260000000000,
          marketCapRank: 2,
          fullyDilutedValuation: 260000000000,
          totalVolume: 25000000000,
          high24H: 2250.00,
          low24H: 2150.00,
          priceChange24H: -50.00,
          priceChangePercentage24H: -2.2,
          marketCapChange24H: -5000000000,
          marketCapChangePercentage24H: -1.9,
          circulatingSupply: 120000000,
          totalSupply: 120000000,
          maxSupply: nil,
          ath: 4878.26,
          athChangePercentage: -54.9,
          athDate: "2021-11-10T14:24:11.849Z",
          atl: 0.432979,
          atlChangePercentage: 508148.0,
          atlDate: "2015-10-20T00:00:00.000Z",
          roi: nil,
          lastUpdated: "2023-10-27T10:00:00.000Z",
          priceChangePercentage24HInCurrency: -2.2
      )
  }
}
#endif
