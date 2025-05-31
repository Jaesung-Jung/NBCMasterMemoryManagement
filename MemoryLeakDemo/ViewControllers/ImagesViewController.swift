//
//  ImagesViewController.swift
//  MemoryLeakDemo
//
//  Created by 정재성 on 5/31/25.
//

import UIKit
import SnapKit
import Then

final class ImagesViewController: UIViewController {
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout()).then {
    $0.delegate = self
    $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
  }

  private let images: [UIImage] = [
    .image1, .image2, .image3, .image4, .image5, .image6
  ]

  private let loadingEffectView = LoadingEffectView()

  private lazy var dataSource = makeCollectionViewDataSource(collectionView)

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Images"

    view.addSubview(collectionView)
    collectionView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
    }

    view.addSubview(loadingEffectView)
    loadingEffectView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
    }

    var snapshot = NSDiffableDataSourceSnapshot<Int, UIImage>()
    snapshot.appendSections([0])
    snapshot.appendItems(images, toSection: 0)
    dataSource.apply(snapshot)
  }
}

// MARK: - ImagesViewController (UICollectionViewDelegate)

extension ImagesViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let image = images[indexPath.item]
    self.loadingEffectView.startAnimating()
    makeJPEGExample(for: image) {
      self.loadingEffectView.stopAnimating()
    }
  }
}

// MARK: - ImagesViewController (Private)

extension ImagesViewController {
  private func makeJPEGExample(for image: UIImage, completion: @escaping () -> Void) {
    DispatchQueue.global().async {
      for offset in 0..<10 {
        let jpeg = image.jpegData(compressionQuality: 0.7)
        print("jpeg size: \(jpeg?.count ?? 0), \(offset) save completed")
      }
      DispatchQueue.main.async {
        completion()
      }
    }
  }

  private func makeCollectionViewLayout() -> UICollectionViewLayout {
    let item = NSCollectionLayoutItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1),
        heightDimension: .fractionalHeight(1)
      )
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1),
        heightDimension: .absolute(200)
      ),
      subitems: [item]
    )
    let section = NSCollectionLayoutSection(group: group).then {
      $0.interGroupSpacing = 20
      $0.contentInsetsReference = .layoutMargins
    }
    return UICollectionViewCompositionalLayout(section: section)
  }

  private func makeCollectionViewDataSource(_ collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Int, UIImage> {
    let cellRegistration = UICollectionView.CellRegistration<ImageItemCell, UIImage> { cell, indexPath, image in
      cell.image = image
    }
    return UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
      collectionView.dequeueConfiguredReusableCell(
        using: cellRegistration,
        for: indexPath,
        item: itemIdentifier
      )
    }
  }
}

// MARK: - ImagesViewController Preview

#Preview {
  UINavigationController(rootViewController: ImagesViewController())
}
