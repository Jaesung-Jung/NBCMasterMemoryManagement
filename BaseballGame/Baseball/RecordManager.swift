//
//  RecordManager.swift
//  BaseballGame
//
//  Created by 정재성 on 5/28/25.
//

final class RecordManager {
  private(set) var records: [Int] = []

  private init() {
    records.append(contentsOf: repeatElement((), count: 5).map { .random(in: 1...9) })
  }

  func append(_ tryCount: Int) {
    records.append(tryCount)
  }
}

extension RecordManager {
  public static let shared = RecordManager()
}
