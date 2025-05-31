//
//  UIImage+Resize.swift
//  MemoryLeakDemo
//
//  Created by 정재성 on 5/31/25.
//

import UIKit

extension UIImage {
  func resize(in boundsSize: CGSize) -> UIImage? {
    let ratio = min(boundsSize.width / size.width, boundsSize.height / size.height)
    return resize(to: CGSize(width: size.width * ratio, height: size.height * ratio))
  }

  func resize(to size: CGSize) -> UIImage? {
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { _ in
      draw(in: CGRect(origin: .zero, size: size))
    }
  }
}
