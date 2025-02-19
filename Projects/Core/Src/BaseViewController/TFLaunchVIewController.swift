//
//  TFLaunchViewController.swift
//  DSKit
//
//  Created by Kanghos on 2023/12/06.
//

import UIKit

import SnapKit
import Then
import Lottie
import DSKit

public final class TFLaunchViewController: TFBaseViewController {
  private lazy var splashLottieView = LottieAnimationView(animation: AnimationAsset.logoSplash.animation)

  public override func loadView() {
    super.loadView()
    self.view.addSubview(splashLottieView)
    splashLottieView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.height.width.equalTo(view.bounds.height * 0.7)
    }

    splashLottieView.play()
  }
}
