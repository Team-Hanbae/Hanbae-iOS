//
//  MetronomeOnOffUseCase.swift
//  Macro
//
//  Created by leejina on 11/8/24.
//

import Combine

protocol MetronomeOnOffUseCase {
    var isPlayingPublisher: AnyPublisher<Bool, Never> { get }
    var tickPublisher: AnyPublisher<Void, Never> { get }
    
    func changeSobak()
    func play()
    func stop()
    func setSoundType()
}
