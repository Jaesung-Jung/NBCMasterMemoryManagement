//
//  LoadingEffectView.swift
//  MemoryLeakDemo
//
//  Created by 정재성 on 5/31/25.
//

import UIKit
import SnapKit
import Then

final class LoadingEffectView: UIView {
  let activityIndicator = UIActivityIndicatorView(style: .large).then {
    $0.color = .white
  }

  init() {
    super.init(frame: .zero)
    let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    addSubview(blurEffectView)
    blurEffectView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
    }

    addSubview(activityIndicator)
    activityIndicator.snp.makeConstraints {
      $0.center.equalToSuperview()
    }

    isHidden = true
    alpha = 0
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func startAnimating() {
    isHidden = false
    activityIndicator.startAnimating()
    UIView.animate(withDuration: 0.25) {
      self.alpha = 1
    }
  }

  func stopAnimating() {
    activityIndicator.stopAnimating()
    UIView.animate(withDuration: 0.25) {
      self.alpha = 0
    } completion: { _ in
      self.isHidden = true
    }
  }
}
