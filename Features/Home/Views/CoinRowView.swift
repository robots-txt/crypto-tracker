import SwiftUI

struct CoinRowView: View {
  let coin: Coin
  let isLast: Bool

  var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 16) {
        // Coin Image
        AsyncImage(url: URL(string: coin.image)) { image in
          image.resizable()
        } placeholder: {
          Circle().fill(Color.clear)
        }
        .frame(width: 40, height: 40)
        .clipShape(Circle())

        // Coin Details
        VStack(alignment: .leading, spacing: 4) {
          // Name and Symbol
          HStack {
            Text(coin.name)
              .font(.headline)
              .foregroundColor(.themeText)
            Spacer()
            Text(coin.symbol.uppercased())
              .font(.subheadline)
              .foregroundColor(.themeAccent)
          }

          // Price and 24h Change
          HStack {
            Text(String(format: "$%.2f", coin.currentPrice))
              .font(.body)
              .foregroundColor(.themeText)
            Spacer()
            
            let isPositiveChange = coin.priceChangePercentage24H >= 0
            
            Text(String(format: "%.2f%%", coin.priceChangePercentage24H))
              .font(.body)
              .foregroundColor(isPositiveChange ? .themeGreen : .themeRed)

            Image(systemName: isPositiveChange ? "chevron.up.circle" : "chevron.down.circle")
              .foregroundColor(isPositiveChange ? .themeGreen : .themeRed)
              .font(.body)
          }

          // Market Cap
          Text("Market Cap: \(Double(coin.marketCap).formattedWithAbbreviations)")
            .font(.caption)
            .foregroundColor(.themeText)
        }
      }
      .padding(.vertical, 12)

      // Manual Divider, hidden for the last item
      if !isLast {
        Divider()
          .padding(.leading, 56) // Indent divider to align with text
      }
    }
    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
    .listRowSeparator(.hidden)
  }
}
