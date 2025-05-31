//
//  MainViewController.swift
//  MemoryLeakDemo
//
//  Created by 정재성 on 5/30/25.
//

import UIKit
import SnapKit
import Then

final class MainViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Main"
    view.backgroundColor = .systemBackground

    let action = UIAction(title: "Image List") { _ in
      self.navigationController?.pushViewController(ImagesViewController(), animated: true)
    }
    let button = UIButton(configuration: .filled(), primaryAction: action)
    view.addSubview(button)
    button.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
}

// MARK: - MainViewController Preview

#Preview {
  UINavigationController(rootViewController: MainViewController())
}
