//
//  PlaySoundInterface.swift
//  Macro
//
//  Created by Yunki on 10/1/24.
//

import Combine

// 소리내는 UseCase용
protocol PlaySoundInterface {
    var callInterruptPublisher: AnyPublisher<Void, Never> { get }
    func audioEngineStart()
    func beep(_ accent: Accent)
    func setSoundType()
}
