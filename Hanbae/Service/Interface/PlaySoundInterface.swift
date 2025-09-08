//
//  PlaySoundInterface.swift
//  Macro
//
//  Created by Yunki on 10/1/24.
//

import Combine

protocol PlaySoundInterface {
    var callInterruptPublisher: AnyPublisher<Void, Never> { get }
    func prepareAudioEngine()
    func pauseAudioEngine()
    func beep(_ accent: Accent)
    func setSoundType()
    func playCountSound()
}
