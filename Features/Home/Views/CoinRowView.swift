import SwiftUI

struct CoinRowView: View {
  let coin: Coin
  let isLast: Bool

  var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: .paddingMedium) {
        // Coin Image
        AsyncImage(url: URL(string: coin.image)) { image in
          image.resizable()
        } placeholder: {
          Circle().fill(Color.clear)
        }
        .frame(width: .iconSize * 1.5, height: .iconSize * 1.5)
        .clipShape(Circle())

        // Coin Details
        VStack(alignment: .leading, spacing: .paddingSmall / 2) {
          // Name and Symbol
          HStack {
            Text(coin.name)
              .font(.headline())
              .foregroundColor(.themeText)
            Spacer()
            Text(coin.symbol.uppercased())
              .font(.subheadline())
              .foregroundColor(.themeAccent)
          }

          // Price and 24h Change
          HStack {
            Text(coin.currentPrice.asCurrencyWith2Decimals())
              .font(.body())
              .foregroundColor(.themeText)
            Spacer()
            
            let isPositiveChange = coin.priceChangePercentage24H >= 0
            
            Text(coin.priceChangePercentage24H.asPercentWith2Decimals())
              .font(.body())
              .foregroundColor(isPositiveChange ? .themeGreen : .themeRed)

            Image(systemName: isPositiveChange ? "chevron.up.circle" : "chevron.down.circle")
              .foregroundColor(isPositiveChange ? .themeGreen : .themeRed)
              .font(.body())
          }

          // Market Cap
          Text("\(Strings.marketCap): \(Double(coin.marketCap).formattedWithAbbreviations)")
            .font(.caption())
            .foregroundColor(.themeText)
        }
      }
      .padding(.vertical, .paddingMedium - .paddingSmall / 2)

      // Manual Divider, hidden for the last item
      if !isLast {
        Divider()
          .padding(.leading, .paddingMedium + .iconSize * 1.5) // Indent divider to align with text
      }
    }
    .listRowInsets(EdgeInsets(top: 0, leading: .paddingMedium, bottom: 0, trailing: .paddingMedium))
    .listRowSeparator(.hidden)
  }
}
