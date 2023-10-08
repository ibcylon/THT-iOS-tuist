//
//  MainCollectionViewItemViewModel.swift
//  Falling
//
//  Created by SeungMin on 2023/10/06.
//

import Foundation

import RxSwift
import RxCocoa

final class MainCollectionViewItemViewModel: ViewModelType {
  
  let userDomain: UserDomain
  
  init(userDomain: UserDomain) {
    self.userDomain = userDomain
  }
  
  enum TimeState {
    case initial(value: Double) // 7~8
    case five(value: Double)  // 6~7
    case four(value: Double) // 5~6
    case three(value: Double) // 4~5
    case two(value: Double) // 3~4
    case one(value: Double) // 2~3
    case zero(value: Double) // 1~2
    case over(value: Double) // 0~1
    
    init(rawValue: Double) {
      switch rawValue {
      case 7.0..<8.0:
        self = .initial(value: rawValue)
      case 6.0..<7.0:
        self = .five(value: rawValue)
      case 5.0..<6.0:
        self = .four(value: rawValue)
      case 4.0..<5.0:
        self = .three(value: rawValue)
      case 3.0..<4.0:
        self = .two(value: rawValue)
      case 2.0..<3.0:
        self = .one(value: rawValue)
      case 1.0..<2.0:
        self = .zero(value: rawValue)
      default:
        self = .over(value: rawValue)
      }
    }
    
    var color: FallingColors {
      switch self {
      case .zero, .five:
        return FallingAsset.Color.primary500
      case .four:
        return FallingAsset.Color.thtOrange100
      case .three:
        return FallingAsset.Color.thtOrange200
      case .two:
        return FallingAsset.Color.thtOrange300
      case .one:
        return FallingAsset.Color.thtRed
      default:
        return FallingAsset.Color.neutral300
      }
    }
    
    var isDotHidden: Bool {
      switch self {
      case .initial, .over:
        return true
      default:
        return false
      }
    }
    
    var fillColor: FallingColors {
      switch self {
      case .over:
        return FallingAsset.Color.neutral300
      default:
        return FallingAsset.Color.clear
      }
    }
    
    var getText: String {
      switch self {
      case .initial, .over:
        return String("-")
      case .five(let value), .four(let value), .three(let value), .two(let value), .one(let value), .zero(let value):
        return String(Int(value) - 1)
      }
    }
    
    var getProgress: Double {
      switch self {
      case .initial:
        return 1
      case .five(let value), .four(let value), .three(let value), .two(let value), .one(let value), .zero(let value), .over(let value):
        return (value - 2) / 5
      }
    }
  }
  
  var disposeBag: DisposeBag = DisposeBag()
  
  struct Input {
    
  }
  
  struct Output {
    let timeState: Driver<TimeState>
    let isTimeOver: Driver<Bool>
  }
  
  func transform(input: Input) -> Output {
    let time = Observable<Int>.interval(.milliseconds(10),
                                        scheduler: MainScheduler.instance)
      .take(8 * 100 + 1)
      .map { round((8 - Double($0) / 100) * 100) / 100 }
      .asDriver(onErrorDriveWith: Driver<Double>.empty())
    
    let timeState = time.map { TimeState(rawValue: $0) }
    let isTimeOver = time.map { $0 == 0.0 }
    
    return Output(
      timeState: timeState,
      isTimeOver: isTimeOver
    )
  }
}
