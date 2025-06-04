//
//  RecordsViewController.swift
//  BaseballGame
//
//  Created by 정재성 on 6/4/25.
//

import UIKit

final class RecordsViewController: UIViewController {
  private let recordsManager = RecordManager.shared

  private let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewCompositionalLayout.list(using: UICollectionLayoutListConfiguration(appearance: .insetGrouped))
  )

  private let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Int> { cell, indexPath, count in
    var configuration = cell.defaultContentConfiguration()
    configuration.text = "\(indexPath.item + 1)번째 게임 : 시도 횟수 - \(count)"
    cell.contentConfiguration = configuration
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.dataSource = self
    collectionView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(collectionView)
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
}

extension RecordsViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    recordsManager.records.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: recordsManager.records[indexPath.item])
  }
}
