//
//  MessageGenerator.swift
//  BaseballGame
//
//  Created by 정재성 on 5/28/25.
//

import Foundation

struct MessageGenerator {
  func startMessage() -> String {
    "< 게임을 시작합니다 >"
  }

  func resultMessage(strike: Int, ball: Int) -> String {
    if strike == 3 {
      return "정답입니다!"
    } else if strike > 0 || ball > 0 {
      let messages = [
        strike > 0 ? "\(strike)스트라이크" : nil,
        ball > 0 ? "\(ball)볼" : nil
      ]
      return messages.compactMap { $0 }.joined(separator: " ")
    } else {
      return "Nothing"
    }
  }
}
