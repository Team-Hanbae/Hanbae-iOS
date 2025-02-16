//
//  TempoUseCase.swift
//  Macro
//
//  Created by leejina on 11/8/24.
//

import Combine
import Foundation

protocol TempoUseCase {
    func updateTempo(newBpm: Int)
    
    /// 현재 빠르기 찾기 기능이 실행중인지 여부를 배포하는 Publisher
    var isTappingPublisher: AnyPublisher<Bool, Never> { get }
    func tap(timeStamp: Date)
    func finishTapping()
}

extension TempoUseCase {
    func tap(timeStamp: Date = .now) { tap(timeStamp: timeStamp) }
}
