//
//  ImageThumbnailGenerator.swift
//  ImageCollection
//
//  Created by 정재성 on 6/1/25.
//

import UIKit

final class ImageWriter {
  var imageDownloader: ImageDownloader?

  func writeToFile(_ image: UIImage, completion: @escaping () -> Void) {
    let sizes: [CGSize] = [0.25, 0.5, 0.75, 1].map {
      CGSize(width: image.size.width * $0, height: image.size.height * $0)
    }
    for size in sizes {
      let resizedImage = image.resize(to: size)
      let png = resizedImage?.pngData()
      write(data: png)
    }

    DispatchQueue.main.async {
      completion()
    }
  }

  private func write(data: Data?) {
    guard let data else {
      return
    }
    _ = data
    // Write to file
  }
}

extension UIImage {
  func resize(to size: CGSize) -> UIImage? {
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { _ in
      draw(in: CGRect(origin: .zero, size: size))
    }
  }
}
