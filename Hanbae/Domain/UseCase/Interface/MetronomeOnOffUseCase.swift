//
//  MetronomeOnOffUseCase.swift
//  Macro
//
//  Created by leejina on 11/8/24.
//

import Combine

protocol MetronomeOnOffUseCase {
    var isPlayingPublisher: AnyPublisher<Bool, Never> { get }
    var tickPublisher: AnyPublisher<(Int,Int,Int), Never> { get }
    var firstTickPublisher: AnyPublisher<Void, Never> { get }
    var precountPublisher: AnyPublisher<Int?, Never> { get }
    
    func play(withPrecount: Bool)
    func stop()
    func setSoundType()
    func initialDaeSoBakIndex()
}

extension MetronomeOnOffUseCase {
    func play() {
        play(withPrecount: false)
    }
}
