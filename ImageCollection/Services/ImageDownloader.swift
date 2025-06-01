//
//  ImageDownloader.swift
//  ImageCollection
//
//  Created by 정재성 on 6/1/25.
//

import UIKit

final class ImageDownloader: NSObject {
  private var currentTask: URLSessionDownloadTask?
  private var completionHandler: ((Status) -> Void)?

  var imageWriter: ImageWriter?

  func downloadImage(_ imageURL: URL, completion: @escaping (Status) -> Void) {
    currentTask?.cancel()
    completionHandler = nil

    let downloadSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
    let task = downloadSession.downloadTask(with: URLRequest(url: imageURL))
    task.resume()

    currentTask = task
    completionHandler = completion
  }
}

// MARK: - ImageDownloader.Status

extension ImageDownloader {
  enum Status {
    case downloading(Float)
    case completed(UIImage?)
  }
}

// MARK: - ImageDownloader (URLSessionDownloadDelegate)

extension ImageDownloader: URLSessionDownloadDelegate {
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    completionHandler?(.downloading(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)))
  }

  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    defer {
      currentTask = nil
      completionHandler = nil
    }
    guard let data = try? Data(contentsOf: location), let image = UIImage(data: data) else {
      completionHandler?(.completed(nil))
      return
    }
    completionHandler?(.completed(image))
  }
}
