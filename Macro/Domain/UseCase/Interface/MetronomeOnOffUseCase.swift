//
//  MetronomeOnOffUseCase.swift
//  Macro
//
//  Created by leejina on 11/8/24.
//

import Combine

protocol MetronomeOnOffUseCase {
    var isPlayingPublisher: AnyPublisher<Bool, Never> { get }
    var isSobakOnPublisher: AnyPublisher<Bool, Never> { get }
    var tickPublisher: AnyPublisher<(Int,Int,Int), Never> { get }
    var firstTickPublisher: AnyPublisher<Void, Never> { get }
    
    func changeSobak()
    func changeBlink()
    func play()
    func stop()
    func setSoundType()
    func initialDaeSoBakIndex()
    func resetOptions()
}
