//
//  ImageCollectionViewController.swift
//  ImageCollection
//
//  Created by 정재성 on 6/1/25.
//

import UIKit
import SnapKit
import Then

final class ImageCollectionViewController: UIViewController {
  private let repository: ImageRepository
  private let category: ImageCategory

  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout()).then {
    $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
  }

  private lazy var dataSource = makeCollectionViewDataSource(collectionView)

  init(category: ImageCategory) {
    self.repository = ImageRepository()
    self.category = category
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "\(category)"
    view.backgroundColor = .systemBackground

    view.addSubview(collectionView)
    collectionView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
    }

    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: nil,
      image: UIImage(systemName: "arrow.trianglehead.2.counterclockwise.rotate.90"),
      primaryAction: UIAction { _ in
        self.fetchImages()
      },
      menu: nil
    )
    fetchImages()
  }
}

// MARK: - ImageCollectionViewController (Private)

extension ImageCollectionViewController {
  @objc private func refreshImages() {
    fetchImages()
  }

  private func fetchImages() {
    repository.fetchImages(category: category) { result in
      let images: [ImageInfo]
      switch result {
      case .success(let items):
        images = items
      case .failure:
        images = []
      }
      DispatchQueue.main.async {
        self.updateImages(images)
      }
    }
  }

  private func updateImages(_ images: [ImageInfo]) {
    var snapshot = NSDiffableDataSourceSnapshot<Int, ImageInfo>()
    snapshot.appendSections([0])
    snapshot.appendItems(images, toSection: 0)
    dataSource.apply(snapshot)
  }

  private func makeCollectionViewDataSource(_ collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Int, ImageInfo> {
    let cellRegistration = UICollectionView.CellRegistration<ImageInfoCell, ImageInfo> { cell, _, imageInfo in
      cell.imageInfo = imageInfo
    }
    return UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item in
      collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
    }
  }

  private func makeCollectionViewLayout() -> UICollectionViewLayout {
    UICollectionViewCompositionalLayout { _, environment in
      let containerSize = environment.container.effectiveContentSize
      let item = NSCollectionLayoutItem(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1),
          heightDimension: .estimated(containerSize.width)
        )
      )
      let grorup = NSCollectionLayoutGroup.horizontal(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1),
          heightDimension: .estimated(containerSize.width)
        ),
        subitems: [item]
      )
      return NSCollectionLayoutSection(group: grorup).then {
        $0.contentInsetsReference = .layoutMargins
        $0.interGroupSpacing = 10
      }
    }
  }
}

// MARK: - ImageCollectionViewController Preview

#Preview {
  NavigationController(rootViewController: ImageCollectionViewController(category: .nature))
}
