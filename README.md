# iOS Crypto Price Tracker

## Project Overview

This is a native iOS application that displays the top 20 cryptocurrencies by market capitalization. It fetches data from the CoinGecko API and presents it in a clean, user-friendly interface. The app is built with modern SwiftUI and follows the MVVM architectural pattern.

## Features

- **Live Crypto Data:** Fetches and displays the top 20 cryptocurrencies, including their name, symbol, price, market cap, and 24-hour price change.
- **Detail View:** Tap on a cryptocurrency to see a detailed view with more information, such as 24h high/low, all-time high, and total volume.
- **Caching:** Implements a 24-hour URLCache to reduce network usage and improve performance. Data is loaded from the cache on subsequent launches.
- **Pull-to-Refresh:** Force a refresh of the data by pulling down on the main list.
- **Error Handling:** Gracefully handles network errors and displays a user-friendly message with a retry option.
- **Unit Tested:** The view model, networking, and caching logic are covered by a suite of unit tests.

## Technology Stack

- **Programming Language:** Swift
- **UI Framework:** SwiftUI
- **Architecture:** MVVM (Model-View-ViewModel)
- **API Integration:** CoinGecko API
- **Caching:** URLCache
- **Navigation:** SwiftUI `NavigationStack` with a custom `Router` class.
- **Testing:** XCTest, with dependency injection and mock objects for testing.

## Project Setup & Requirements

### Prerequisites

- **Xcode:** Version 26.0.1 or newer.
- **iOS:** Minimum deployment target is iOS 16.0.

### How to Run the Project

1.  **Clone the Repository:**
    ```bash
    git clone git@github.com:robots-txt/crypto-tracker.git
    cd crypto-tracker
    ```

2.  **Open the Project in Xcode:**
    Open the `CryptoPriceTracker.xcodeproj` file in Xcode.

3.  **Run the App:**
    Select an iOS 16.0+ simulator (e.g., iPhone 15 Pro) and click the "Run" button (or press `Cmd+R`).

### How to Run Unit Tests

1.  **Open the Project in Xcode:**
    As above, open the `CryptoPriceTracker.xcodeproj` file.

2.  **Run the Tests:**
    Go to the menu bar and select **Product > Test** (or press `Cmd+U`). The tests will run in the background, and you can see the results in the Test Navigator (the diamond icon on the left).

## Architectural Notes

- **Dependency Injection:** The `HomeViewModel` and `NetworkManager` are set up to allow for dependency injection, which is used extensively in the unit tests and Xcode Previews.
- **Externalized Resources:** All strings, colors, fonts, and common sizes are externalized into their own files in the `Common/Constants` directory for easy localization and styling changes.
- **Mock Data for Previews:** The Xcode Previews for `ContentView` and `CoinDetailView` use mock data to ensure they are fast, reliable, and do not make live network calls.

## Future Enhancements

Here are some potential future enhancements to extend the functionality and user experience of this project:

-   **Coin List View Pagination:** Implement pagination to efficiently load and display a larger number of cryptocurrencies, improving performance and user experience for extensive lists.
-   **Graph View in Detail Screen:** Integrate a graph view in the `CoinDetailView` to visualize historical price data for a selected cryptocurrency, providing deeper insights.
-   **Search Functionality:** Add a search bar to allow users to quickly find specific cryptocurrencies by name or symbol.
-   **User Favorites:** Implement a feature for users to mark and manage their favorite cryptocurrencies, providing quick access to their preferred assets.
-   **Settings/Preferences:** Introduce a settings screen where users can customize various app behaviors, such as preferred currency, data refresh intervals, and notification preferences.
-   **Accessibility Improvements:** Enhance accessibility features to ensure the app is usable and enjoyable for individuals with diverse needs, adhering to Apple's accessibility guidelines.