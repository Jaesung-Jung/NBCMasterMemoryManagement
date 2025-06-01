//
//  ImaeInfo.swift
//  ImageCollection
//
//  Created by 정재성 on 6/1/25.
//

import Foundation

struct ImageInfo: Decodable {
  let id: String
  let width: Int
  let height: Int
  let description: String?
  let createdAt: Date?
  let images: Images
  let likes: Int
  let user: User

  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: StringCodingKey.self)
    id = try container.decode(String.self, forKey: "id")
    width = try container.decode(Int.self, forKey: "width")
    height = try container.decode(Int.self, forKey: "height")
    description = try container.decodeIfPresent(String.self, forKey: "description") ?? container.decodeIfPresent(String.self, forKey: "alt_description")
    createdAt = try container.decode(Date.self, forKey: "created_at")
    images = try container.decode(Images.self, forKey: "urls")
    likes = try container.decode(Int.self, forKey: "likes")
    user = try container.decode(User.self, forKey: "user")
  }
}

// MARK: - ImageInfo.Images

extension ImageInfo {
  struct Images: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
  }
}
