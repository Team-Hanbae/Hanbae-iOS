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
    private var isBlinkOn: Bool
    
    // 현재 진행중인 박 위치 관련 변수
    private var currentSobak: Int = 0
    private var currentDaebak: Int = 0
    private var currentRow: Int = 0
    
    private var isPlayingSubject: PassthroughSubject<Bool, Never> = .init()
    private var isSobakOnSubject: PassthroughSubject<Bool, Never> = .init()
    private var tickSubject: PassthroughSubject<(Int,Int,Int), Never> = .init()
    private var firstTickSubject: PassthroughSubject<Void, Never> = .init()
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
        self.isBlinkOn = false
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
        
        self.soundManager.callInterruptPublisher.sink {[weak self] in
            self?.stop()
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
    
    var tickPublisher: AnyPublisher<(Int,Int,Int), Never> {
        self.tickSubject.eraseToAnyPublisher()
    }
    
    var firstTickPublisher: AnyPublisher<Void, Never> {
        self.firstTickSubject.eraseToAnyPublisher()
    }
    
    func changeSobak() {
        self.isSobakOn.toggle()
        self.isSobakOnSubject.send(self.isSobakOn)
    }
    
    func changeBlink() {
        self.isBlinkOn.toggle()
    }
    
    func play() {
        // AudioEngine start()
        self.soundManager.audioEngineStart()
        // 데이터 갱신
        self.currentBeatIndex = 0
        self.initialDaeSoBakIndex()
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
        // timer 카운트를 해주고, 틱마다 publish
        self.updateStatePerBak()
        self.tickSubject.send((currentSobak, currentDaebak, currentRow))
        if self.currentSobak == 0 {
            self.firstTickSubject.send()
        }
        
        let accent: Accent = jangdanAccentList[self.currentBeatIndex % jangdanAccentList.count]
        self.soundManager.beep(accent)
        self.currentBeatIndex += 1
    }
    
    private func updateStatePerBak() {
        var nextSobak: Int = self.currentSobak
        var nextDaebak: Int = self.currentDaebak
        var nextRow: Int = self.currentRow
        
        nextSobak += 1
        if nextSobak == self.jangdan[nextRow][nextDaebak].count {
            nextDaebak += 1
            if nextDaebak == self.jangdan[nextRow].count {
                nextRow += 1
                if nextRow == self.jangdan.count {
                    nextRow = 0
                }
                nextDaebak = 0
            }
            nextSobak = 0
        }
        
        self.currentSobak = nextSobak
        self.currentDaebak = nextDaebak
        self.currentRow = nextRow
    }
    
    func initialDaeSoBakIndex() {
        self.currentRow = self.jangdan.count - 1
        self.currentDaebak = self.jangdan[self.currentRow].count - 1
        self.currentSobak = self.jangdan[self.currentRow][self.currentDaebak].count - 1
    }
}
