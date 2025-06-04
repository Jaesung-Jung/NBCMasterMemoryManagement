//
//  ImageWriter.swift
//  ImageCollection
//
//  Created by 정재성 on 6/4/25.
//

import UIKit

final class ImageWriter {
  var delegate: Delegate?

  func writeImage(_ image: UIImage) {
    DispatchQueue.global().async {
      let jpeg = image.jpegData(compressionQuality: 0.75)
      do {
        try jpeg?.write(to: .downloadsDirectory.appending(path: "\(UUID().uuidString).jpg"))
        DispatchQueue.main.async {
          self.delegate?.imageWrite(self, didCompleteWriteFilesWithError: nil)
        }
      } catch {
        let error = error
        DispatchQueue.main.async {
          self.delegate?.imageWrite(self, didCompleteWriteFilesWithError: error)
        }
      }
    }
  }
}

extension ImageWriter {
  protocol Delegate {
    func imageWrite(_ imageWriter: ImageWriter, didCompleteWriteFilesWithError error: Error?)
  }
}
