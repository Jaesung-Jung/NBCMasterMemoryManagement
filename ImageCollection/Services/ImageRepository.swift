//
//  ImageRepository.swift
//  ImageCollection
//
//  Created by 정재성 on 6/1/25.
//

import Foundation
import Then

struct ImageRepository {
  private let host = URL(string: "https://unsplash.com")!
  private let session = URLSession.shared

  func fetchImages(category: ImageCategory, page: Int, count: Int, completion: @escaping (Result<[ImageInfo], Swift.Error>) -> Void) {
    do {
      let request = try makeURLRequest(path: "/napi/topics/\(category.rawValue)/photos", page: page, count: count)
      session.dataTask(with: request) { data, _, error in
        guard let data else {
          completion(.failure(error ?? Error.unknown))
          return
        }
        do {
          let decoder = JSONDecoder().then {
            $0.dateDecodingStrategy = .iso8601
          }
          try completion(.success(decoder.decode([ImageInfo].self, from: data)))
        } catch {
          completion(.failure(error))
        }
      }
      .resume()
    } catch {
      completion(.failure(error))
    }
  }
}

// MARK: - ImageRepository (Private)

extension ImageRepository {
  private func makeURLRequest(path: String, page: Int, count: Int) throws(Error) -> URLRequest {
    var component = URLComponents()
    component.path = path
    component.queryItems = [
      URLQueryItem(name: "page", value: "\(page)"),
      URLQueryItem(name: "per_page", value: "\(count)")
    ]
    guard let url = component.url(relativeTo: host) else {
      throw .failedMakeURLRequest
    }
    return URLRequest(url: url)
  }
}

// MARK: - ImageRepository.Error

extension ImageRepository {
  enum Error: Swift.Error {
    case failedMakeURLRequest
    case unknown
  }
}
