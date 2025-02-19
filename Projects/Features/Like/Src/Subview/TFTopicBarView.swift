//
//  TFTopicBarView.swift
//  Falling
//
//  Created by Kanghos on 2023/09/14.
//

import UIKit

import SnapKit
import Core
import DSKit

final class TFTopicBarView: TFBaseView {
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 10
    stackView.distribution = .fill
    stackView.alignment = .center
    return stackView
  }()
  private lazy var titleLabel: TFPaddingLabel = {
    let label = TFPaddingLabel()
    label.layer.borderWidth = 1
    label.layer.borderColor = DSKitAsset.Color.primary500.color.cgColor
    label.textColor = DSKitAsset.Color.primary500.color
    label.font = UIFont.thtSubTitle2Sb
    label.textAlignment = .center
    label.clipsToBounds = true
    return label
  }()
  
  private lazy var contentLabel: UILabel = {
    let label = UILabel()
    label.textColor = DSKitAsset.Color.neutral50.color
    label.font = UIFont.thtSubTitle2Sb
    label.numberOfLines = 2
    label.textAlignment = .left
    label.lineBreakMode = .byCharWrapping
    return label
  }()
  
  lazy var closeButton: UIButton = {
    let button = UIButton()
    var config = UIButton.Configuration.plain()
    config.image = DSKitAsset.Image.close.image.withTintColor(
      DSKitAsset.Color.neutral50.color,
      renderingMode: .alwaysOriginal
    )
    config.imagePlacement = .all
    config.baseBackgroundColor = DSKitAsset.Color.topicBackground.color
    button.configuration = config
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func makeUI() {
    self.backgroundColor = UIColor(named: "TopicBackground")
    self.layer.borderWidth = 1
    self.layer.borderColor = UIColor(named: "TopicBorder")?.cgColor

    stackView.addArrangedSubviews([titleLabel, contentLabel])
    self.addSubviews([stackView, closeButton])

    stackView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(10)
      $0.top.bottom.equalToSuperview().inset(8)
      $0.trailing.equalTo(closeButton.snp.leading).offset(-8)
    }
    closeButton.snp.makeConstraints {
      $0.size.equalTo(18)
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().inset(14)
    }
  }
  
  override func layoutSubviews() {
    self.layer.cornerRadius = self.frame.height / 2
    titleLabel.layer.cornerRadius = titleLabel.frame.height / 2
    titleLabel.layer.masksToBounds = true
    titleLabel.layoutIfNeeded()

  }
  
  func bind(title: String, content: String) {
    titleLabel.text = title
    contentLabel.text = content
  }

  func bind(_ viewModel: TopicViewModel) {
    titleLabel.text = viewModel.topic
    contentLabel.text = viewModel.issue
  }
}

struct TopicViewModel {
  let topic: String
  let issue: String
}

