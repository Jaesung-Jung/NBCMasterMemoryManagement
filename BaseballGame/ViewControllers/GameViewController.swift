//
//  GameViewController.swift
//  BaseballGame
//
//  Created by 정재성 on 6/4/25.
//

import UIKit

final class GameViewController: UIViewController, BaseballGame.Delegate {
  @IBOutlet var textField: UITextField!
  @IBOutlet var textLabel: UILabel!
  @IBOutlet var confirmButton: UIButton!

  private let game = BaseballGame()

  override func viewDidLoad() {
    super.viewDidLoad()
    game.delegate = self

    let textEditingAction = UIAction { _ in
      // 입력 3자리 제한
      self.textField.text = self.textField.text.map { String($0.prefix(3)) }
      // 3자리 입력 시 버튼 활성화
      self.confirmButton.isEnabled = self.textField.text.map { $0.count == 3 } ?? false
    }
    textField.addAction(textEditingAction, for: .editingChanged)

    let confirmAction = UIAction { _ in
      guard let text = self.textField.text else {
        return
      }
      let numbers = text.compactMap({ $0.wholeNumberValue })
      self.game.checkNumbers(numbers)
    }
    confirmButton.addAction(confirmAction, for: .primaryActionTriggered)

    game.start()
  }

  func baseballGame(_ baseballGame: BaseballGame, resultMessage: String) {
    textLabel.text = resultMessage
  }

  func baseballGame(_ baseballGame: BaseballGame, didFinish count: Int) {
    confirmButton.isEnabled = false
    textField.isEnabled = false
    RecordManager.shared.append(count)
  }
}
