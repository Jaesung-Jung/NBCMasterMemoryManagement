//
//  BaseballGame.swift
//  BaseballGame
//
//  Created by 정재성 on 5/28/25.
//

class BaseballGame {
  private let messageGenerator = MessageGenerator()
  private var answer: [Int]? = nil
  private var tryCount: Int = 0

  var delegate: Delegate?

  func start() {
    answer = generateAnswer()
    delegate?.baseballGame(self, resultMessage: messageGenerator.startMessage())
  }

  func checkNumbers(_ numbers: [Int]) {
    guard let answer else {
      return
    }
    let (strike, ball) = answer.enumerated().reduce(into: (strike: 0, ball: 0)) { result, item in
      if numbers[item.offset] == item.element {
        result.strike += 1
      } else if numbers[(item.offset + 1) % answer.count] == item.element || numbers[(item.offset + 2) % answer.count] == item.element {
        result.ball += 1
      }
    }
    let message = messageGenerator.resultMessage(strike: strike, ball: ball)
    delegate?.baseballGame(self, resultMessage: message)
    if strike == 3 {
      delegate?.baseballGame(self, didFinish: tryCount)
    } else {
      tryCount += 1
    }
  }

  private func generateAnswer() -> [Int] {
    let firstNumber = Int.random(in: 1...9)
    return [[firstNumber], (0...9).filter { $0 != firstNumber }.shuffled().prefix(2)].flatMap { $0 }
  }
}

// MARK: - BaseballGame.Delegate

extension BaseballGame {
  protocol Delegate: AnyObject {
    func baseballGame(_ baseballGame: BaseballGame, resultMessage: String)
    func baseballGame(_ baseballGame: BaseballGame, didFinish count: Int)
  }
}
