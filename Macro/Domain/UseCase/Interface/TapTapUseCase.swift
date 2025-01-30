//
//  TapTapUseCase.swift
//  Macro
//
//  Created by leejina on 11/8/24.
//

import Combine
import Foundation

protocol TapTapUseCase {
    var isTappingPublisher: AnyPublisher<Bool, Never> { get }
    func tap(timeStamp: Date) -> Int?
    func finishTapping()
}
