import SwiftUI

struct CoinDetailView: View {
  let coin: Coin

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: .paddingMedium) {
        // Header
        HStack {
          AsyncImage(url: URL(string: coin.image)) { image in
            image.resizable()
          } placeholder: {
            Circle().fill(Color.clear)
          }
          .frame(width: 60, height: 60)
          .clipShape(Circle())
          
          VStack(alignment: .leading) {
            Text(coin.name)
              .font(.appTitle())
            Text(coin.symbol.uppercased())
              .font(.headline())
          }
        }

        Divider()

        // Key Stats
        VStack(alignment: .leading, spacing: .paddingSmall) {
          Text(Strings.keyStatistics)
            .font(.headline())
          
          StatRow(title: Strings.currentPrice, value: coin.currentPrice.asCurrencyWith2Decimals())
          StatRow(title: Strings.marketCapitalization, value: Double(coin.marketCap).formattedWithAbbreviations)
          StatRow(title: Strings.high24h, value: coin.high24H.asCurrencyWith2Decimals())
          StatRow(title: Strings.low24h, value: coin.low24H.asCurrencyWith2Decimals())
        }

        Divider()

        // Additional Details
        VStack(alignment: .leading, spacing: .paddingSmall) {
          Text(Strings.additionalDetails)
            .font(.headline())
          
          StatRow(title: Strings.allTimeHigh, value: coin.ath.asCurrencyWith2Decimals())
          StatRow(title: Strings.athDate, value: coin.athDate.asFormattedDateString)
          StatRow(title: Strings.totalVolume, value: coin.totalVolume.formattedWithAbbreviations)
          StatRow(title: Strings.lastUpdated, value: coin.lastUpdated.asFormattedDateString)
        }
      }
      .padding(.paddingMedium)
    }
    .navigationTitle(coin.name)
    .navigationBarTitleDisplayMode(.inline)
  }
}

struct StatRow: View {
  let title: String
  let value: String

  var body: some View {
    HStack {
      Text(title)
        .foregroundColor(.themeAccent)
      Spacer()
      Text(value)
        .foregroundColor(.themeText)
    }
  }
}

#if DEBUG
#Preview {
  NavigationView {
    CoinDetailView(coin: Coin.mock)
  }
}
#endif
