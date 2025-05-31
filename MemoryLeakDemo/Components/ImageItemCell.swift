//
//  ImageItemCell.swift
//  MemoryLeakDemo
//
//  Created by 정재성 on 5/31/25.
//

import UIKit
import SnapKit
import Then

final class ImageItemCell: UICollectionViewCell {
  private let effectImageView = EffectImageView()

  private let overlayEffectView = UIView().then {
    $0.backgroundColor = .black.withAlphaComponent(0.3)
    $0.alpha = 0
    $0.layer.cornerRadius = 12
  }

  override var intrinsicContentSize: CGSize {
    CGSize(width: UIView.noIntrinsicMetric, height: 200)
  }

  var image: UIImage? {
    get { effectImageView.image }
    set { effectImageView.image = newValue }
  }

  override var isHighlighted: Bool {
    didSet {
      UIView.animate(withDuration: 0.25) {
        self.overlayEffectView.alpha = self.isHighlighted ? 1 : 0
      }
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(effectImageView)
    effectImageView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
    }

    contentView.addSubview(overlayEffectView)
    overlayEffectView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
    }

    let textLabel = UILabel().then {
      $0.text = "Download"
      $0.textColor = .white
      $0.font = .systemFont(ofSize: 17, weight: .black)
    }
    contentView.addSubview(textLabel)
    textLabel.snp.makeConstraints {
      $0.bottom.trailing.equalToSuperview().inset(16)
    }

    let donwloadIconView = UIImageView(
      image: UIImage(
        systemName: "arrow.down.circle.fill",
        withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20, weight: .black))
          .applying(UIImage.SymbolConfiguration(hierarchicalColor: .white))
      )
    )
    contentView.addSubview(donwloadIconView)
    donwloadIconView.snp.makeConstraints {
      $0.trailing.equalTo(textLabel.snp.leading).offset(-8)
      $0.centerY.equalTo(textLabel)
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - ImageItemCell Preview

#Preview {
  ImageItemCell().then {
    $0.image = .image4
  }
}
