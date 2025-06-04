//
//  ImageDetailViewController.swift
//  ImageCollection
//
//  Created by 정재성 on 6/1/25.
//

import UIKit
import SnapKit
import Kingfisher
import Then

final class ImageDetailViewController: UIViewController {
  private let imageItem: ImageItem

  private let imageDownloader: ImageDownloader
  private let imageWriter: ImageWriter

  private let profileImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 20
  }

  private let userNameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 17, weight: .semibold)
  }

  private let createdDateLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 13, weight: .semibold)
    $0.textColor = .secondaryLabel
  }

  private let likeCountView = LikeCountView().then {
    $0.font = .systemFont(ofSize: 13, weight: .semibold)
  }

  private let imageView = UIImageView().then {
    $0.backgroundColor = .systemGray6
  }

  private let descriptionLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 17, weight: .bold)
    $0.numberOfLines = 0
    $0.textAlignment = .center
  }

  private let imageSizeLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 13, weight: .medium)
    $0.textColor = .secondaryLabel
  }

  private let downloadButton = UIButton(configuration: .filled()).then {
    $0.configuration?.image = UIImage(systemName: "arrow.down.circle")
    $0.configuration?.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(
      font: .systemFont(ofSize: 17, weight: .bold)
    )
    $0.configuration?.attributedTitle = AttributedString("Download")
      .settingAttributes(AttributeContainer([.font: UIFont.systemFont(ofSize: 17, weight: .bold)]))
    $0.configuration?.imagePadding = 8
    $0.configuration?.buttonSize = .large
  }

  init(imageItem: ImageItem) {
    self.imageItem = imageItem
    self.imageDownloader = ImageDownloader()
    self.imageWriter = ImageWriter()
    self.imageDownloader.imageWriter = self.imageWriter
    self.imageWriter.imageDownloader = self.imageDownloader
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    ImageCache.default.clearMemoryCache()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = imageItem.description ?? imageItem.user.name
    navigationItem.largeTitleDisplayMode = .never
    view.backgroundColor = .systemBackground

    let scrollView = UIScrollView()
    view.addSubview(scrollView)
    scrollView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
    }

    let contentView = UIView()
    scrollView.addSubview(contentView)
    contentView.snp.makeConstraints {
      $0.directionalEdges.equalTo(scrollView.contentLayoutGuide)
      $0.width.equalTo(scrollView.frameLayoutGuide)
      $0.height.greaterThanOrEqualTo(scrollView.safeAreaLayoutGuide).priority(.low)
    }

    // Profile Image
    contentView.addSubview(profileImageView)
    profileImageView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(8)
      $0.leading.equalToSuperview().inset(16)
      $0.size.equalTo(40)
    }

    // Name
    contentView.addSubview(userNameLabel)
    userNameLabel.snp.makeConstraints {
      $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
      $0.trailing.equalToSuperview().inset(16)
      $0.top.equalTo(profileImageView)
    }

    // Created date
    contentView.addSubview(createdDateLabel)
    createdDateLabel.snp.makeConstraints {
      $0.leading.equalTo(userNameLabel)
      $0.bottom.equalTo(profileImageView)
    }

    // Like
    contentView.addSubview(likeCountView)
    likeCountView.snp.makeConstraints {
      $0.centerY.equalTo(createdDateLabel)
      $0.trailing.equalToSuperview().inset(16)
    }

    // Image
    contentView.addSubview(imageView)
    imageView.snp.makeConstraints {
      $0.top.equalTo(profileImageView.snp.bottom).offset(8)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(imageView.snp.width).multipliedBy(CGFloat(imageItem.height) / CGFloat(imageItem.width))
    }

    // Description
    contentView.addSubview(descriptionLabel)
    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.bottom).offset(8)
      $0.leading.trailing.equalToSuperview().inset(16)
    }

    // Image size
    contentView.addSubview(imageSizeLabel)
    imageSizeLabel.snp.makeConstraints {
      $0.top.equalTo(descriptionLabel.snp.bottom).offset(2)
      $0.centerX.equalTo(descriptionLabel)
    }

    // Download
    contentView.addSubview(downloadButton)
    downloadButton.snp.makeConstraints {
      $0.top.greaterThanOrEqualTo(imageSizeLabel.snp.bottom).offset(16)
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.bottom.equalToSuperview().inset(16)
    }

    configure()
  }
}

// MARK: - ImageDetailViewController (Private)

extension ImageDetailViewController {
  private func downloadImage() {
    guard let imageURL = URL(string: imageItem.images.raw) else {
      return
    }
    downloadButton.isEnabled = false
    downloadButton.configuration?.showsActivityIndicator = true
    imageDownloader.downloadImage(imageURL) {
      switch $0 {
      case .downloading(let progress):
        print("Downloading progress: \(progress)")
      case .completed(let image):
        if let image {
          self.imageWriter.writeToFile(image) {
            self.downloadButton.isEnabled = true
            self.downloadButton.configuration?.showsActivityIndicator = false
          }
        }
      }
    }
  }

  private func configure() {
    let action = UIAction { [unowned self] _ in self.downloadImage() }
    downloadButton.addAction(action, for: .primaryActionTriggered)

    if let profileImageURL = imageItem.user.profileImageURL {
      profileImageView.kf.setImage(with: profileImageURL)
    }
    userNameLabel.text = imageItem.user.name
    if let createdAt = imageItem.createdAt {
      createdDateLabel.text = createdAt.formatted(date: .abbreviated, time: .omitted)
    } else {
      createdDateLabel.text = "-"
    }

    if let imageURL = URL(string: imageItem.images.raw) {
      imageView.kf.setImage(with: imageURL)
    }

    descriptionLabel.text = imageItem.description ?? "-"
    imageSizeLabel.text = "\(imageItem.width.formatted(.number))x\(imageItem.height.formatted(.number))"
    likeCountView.count = imageItem.likes
  }
}

// MARK: - ImageDetailViewController Preview

#Preview {
  NavigationController(rootViewController: ImageDetailViewController(imageItem: .preview))
}
