import SwiftUI

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
  private let url: URL?
  private let content: (Image) -> Content
  private let placeholder: () -> Placeholder

  @State private var image: UIImage?

  init(url: URL?, @ViewBuilder content: @escaping (Image) -> Content, @ViewBuilder placeholder: @escaping () -> Placeholder) {
    self.url = url
    self.content = content
    self.placeholder = placeholder
  }

  var body: some View {
    if let image = image {
      content(Image(uiImage: image))
    } else {
      placeholder()
        .onAppear(perform: loadImage)
    }
  }

  private func loadImage() {
    guard let url = url else { return }

    // Check cache first
    if let cachedImage = ImageCache.shared.get(forKey: url.absoluteString) {
      self.image = cachedImage
      return
    }

    // If not in cache, fetch and store
    URLSession.shared.dataTask(with: url) { data, _, _ in
      guard let data = data, let uiImage = UIImage(data: data) else { return }
      ImageCache.shared.set(forKey: url.absoluteString, image: uiImage)
      DispatchQueue.main.async {
        self.image = uiImage
      }
    }.resume()
  }
}
