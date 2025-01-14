//
//  TagCollectionView.swift
//  Like
//
//  Created by Kanghos on 2023/12/20.
//

import UIKit

import DSKit
import Core

import SnapKit

final class TagCollectionView: TFBaseView {
  lazy var sections: [ProfileInfoSection] = [] {
    didSet {
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }
  }
  lazy var reportButton: UIButton = {
    let button = UIButton()
    var config = UIButton.Configuration.plain()
    config.image = DSKitAsset.Image.reportFill.image.withTintColor(
      DSKitAsset.Color.neutral50.color,
      renderingMode: .alwaysOriginal
    )
    config.imagePlacement = .all
    config.baseBackgroundColor = DSKitAsset.Color.topicBackground.color
    button.configuration = config

    config.automaticallyUpdateForSelection = true
    return button
  }()

  lazy var collectionView: UICollectionView = {
    let layout = LeftAlignCollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    layout.headerReferenceSize = CGSize(width: 200, height: 50)

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(cellType: TagCollectionViewCell.self)
    collectionView.register(cellType: ProfileIntroduceCell.self)
    collectionView.register(viewType: TFCollectionReusableView.self, kind: UICollectionView.elementKindSectionHeader)
    collectionView.backgroundColor = DSKitAsset.Color.neutral600.color
    collectionView.isScrollEnabled = false
    collectionView.dataSource = self
    return collectionView
  }()

  override func makeUI() {
    addSubview(collectionView)
    addSubview(reportButton)
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    reportButton.snp.makeConstraints {
      $0.trailing.top.equalToSuperview().inset(12)
    }
  }
}

extension TagCollectionView: UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return self.sections.count
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard section < 2 else {
      return 1
    }
    return self.sections[section].items.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard indexPath.section < 2 else {
      let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ProfileIntroduceCell.self)
      cell.bind(self.sections[indexPath.section].introduce)
      return cell
    }
    let item = self.sections[indexPath.section].items[indexPath.item]
    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: TagCollectionViewCell.self)
    cell.bind(TagItemViewModel(item))
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableView(for: indexPath, ofKind: kind, viewType: TFCollectionReusableView.self)
    header.title = self.sections[indexPath.section].header
    return header
  }
}

class LeftAlignCollectionViewFlowLayout: UICollectionViewFlowLayout {

  let cellSpacing: CGFloat = 10

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

    self.minimumLineSpacing = 10.0
        sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

      let attributes = super.layoutAttributesForElements(in: rect)

      var xPosition = sectionInset.left // Left Maring cell 추가하면 변경하고 line count에 따라 초기화
      var lineCount = -1.0 // lineCount

      // lineCount해서 전체 레이아웃을 넘어가면 line 증가
      attributes?.forEach { attribute in
        if attribute.representedElementKind == UICollectionView.elementKindSectionHeader {
          attribute.frame.origin.x = sectionInset.left
          return
        }
        if attribute.indexPath.section == 2 { // 자기소개 셀
          return
        }
        if attribute.frame.origin.y >= lineCount { // xPosition 초기화
          xPosition = sectionInset.left
        }
        attribute.frame.origin.x = xPosition
        xPosition += attribute.frame.width + cellSpacing
        lineCount = max(attribute.frame.maxY, lineCount)
      }
      return attributes
}
}
