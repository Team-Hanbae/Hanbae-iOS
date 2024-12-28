//
//  MetronomeOnOffUseCase.swift
//  Macro
//
//  Created by leejina on 11/8/24.
//

import Combine

protocol MetronomeOnOffUseCase {
    var isPlayingPublisher: AnyPublisher<Bool, Never> { get }
    
    func changeSobak()
    func play(_ tickHandler: @escaping () -> Void )
    func stop()
    func setSoundType()
}
