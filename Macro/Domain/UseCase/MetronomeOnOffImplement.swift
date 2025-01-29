//
//  MetronomeOnOffImplement.swift
//  Macro
//
//  Created by Yunki on 10/1/24.
//

import Foundation
import Combine
import UIKit.UIApplication

class MetronomeOnOffImplement {
    private var jangdan: [[[Accent]]]
    private var jangdanAccentList: [Accent] {
        if self.isSobakOn {
            return jangdan.flatMap { $0 }.flatMap { $0 }
        } else {
            return jangdan.flatMap { $0 }.map { $0.enumerated().map { $0.offset == 0 ? $0.element : .none }}.flatMap { $0 }
        }
    }
    
    private var bpm: Double
    private var currentBeatIndex: Int
    private var isSobakOn: Bool
    
    private var isPlayingSubject: PassthroughSubject<Bool, Never> = .init()
    private var isSobakOnSubject: PassthroughSubject<Bool, Never> = .init()
    private var tickSubject: PassthroughSubject<Void, Never> = .init()
    private var cancelBag: Set<AnyCancellable> = []
    
    // timer
    private var timer: DispatchSourceTimer?
    private let queue = DispatchQueue(label: "metronomeTimer", qos: .userInteractive) // 다른 스레드
    private var interval: TimeInterval {
        60.0 / bpm
    }
    private var lastPlayTime: Date
    private var jangdanRepository: JangdanRepository
    private var soundManager: PlaySoundInterface
    
    init(jangdanRepository: JangdanRepository, soundManager: PlaySoundInterface) {
        self.jangdan = [[[.medium]]]
        self.bpm = 60.0
        self.currentBeatIndex = 0
        self.isSobakOn = false
        self.lastPlayTime = .now
        self.jangdanRepository = jangdanRepository
        self.soundManager = soundManager
        
        self.jangdanRepository.jangdanPublisher.sink { [weak self] jangdanEntity in
            guard let self else { return }
            self.jangdan = jangdanEntity.daebakList.map { $0.map { $0.bakAccentList } }
            let daebakCount = self.jangdan.reduce(0) { $0 + $1.count }
            let bakCount = self.jangdan.reduce(0) { $0 + $1.reduce(0) { $0 + $1.count } }
            let averageSobakCount = Double(bakCount) / Double(daebakCount)
            
            // 직전 play() 시점 및 interval을 통한 다음 play() 시점 찾기
            let nextPlayTime = self.lastPlayTime.addingTimeInterval(self.interval)
            self.bpm = Double(jangdanEntity.bpm) * averageSobakCount
            let nextStartTime = nextPlayTime.timeIntervalSince(.now)
            self.timer?.schedule(deadline: .now() + nextStartTime, repeating: self.interval, leeway: .nanoseconds(1))
        }
        .store(in: &self.cancelBag)
        
        self.soundManager.callInterruptPublisher.sink {[weak self] callInterrupt in
        guard let self else { return }
            callInterrupt == true ? self.stop() : nil
        }
        .store(in: &self.cancelBag)
    }
}

// Play / Stop
extension MetronomeOnOffImplement: MetronomeOnOffUseCase {
    var isPlayingPublisher: AnyPublisher<Bool, Never> {
        self.isPlayingSubject.eraseToAnyPublisher()
    }
    
    var isSobakOnPublisher: AnyPublisher<Bool, Never> {
        self.isSobakOnSubject.eraseToAnyPublisher()
    }
    
    var tickPublisher: AnyPublisher<Void, Never> {
        self.tickSubject.eraseToAnyPublisher()
    }
    
    func changeSobak() {
        self.isSobakOn.toggle()
        self.isSobakOnSubject.send(self.isSobakOn)
    }
    
    func play() {
        // 데이터 갱신
        self.currentBeatIndex = 0
        UIApplication.shared.isIdleTimerDisabled = true
        // Timer 설정
        if let timer { self.stop() }
        self.timer = DispatchSource.makeTimerSource(queue: self.queue)
        self.timer?.schedule(deadline: .now(), repeating: self.interval, leeway: .nanoseconds(1))
        self.timer?.setEventHandler { [weak self] in
            guard let self = self else { return }
            self.lastPlayTime = .now
            self.timerHandler()
        }
        
        // play 여부 publish
        self.isPlayingSubject.send(true)
        // Timer 실행
        self.timer?.resume()
    }
    
    func stop() {
        UIApplication.shared.isIdleTimerDisabled = false
        self.timer?.cancel()
        self.timer = nil
        // stop 여부 publish
        self.isPlayingSubject.send(false)
    }
    
    func setSoundType() {
        self.soundManager.setSoundType()
    }
    
    private func timerHandler() {
        // timer 틱마다 publish
        self.tickSubject.send()
        
        let accent: Accent = jangdanAccentList[self.currentBeatIndex % jangdanAccentList.count]
        self.soundManager.beep(accent)
        self.currentBeatIndex += 1
    }
}
