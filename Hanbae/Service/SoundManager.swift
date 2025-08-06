//
//  SoundManager.swift
//  Macro
//
//  Created by Yunki on 10/3/24.
//

import SwiftUI
import Combine
import AVFoundation
import OSLog

class SoundManager {
    
    private var appState: AppState
    
    private var engine: AVAudioEngine
    private var playerNodePool: [AVAudioPlayerNode] = []
    private var poolIndex: Int = 0
    
    private var audioBuffers: [Accent: AVAudioPCMBuffer] = [:]
    private let audioSession = AVAudioSession.sharedInstance()
    private var soundType: SoundType
    
    private var publisher: PassthroughSubject<Void, Never> = .init()
    
    private var lastBeepTime: CFAbsoluteTime?
    private var logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Macro", category: "SoundManager")
    
    init?(appState: AppState) {
        self.appState = appState
        self.soundType = .clave
        self.engine = AVAudioEngine()
        
        // AudioSession 설정
        do {
            try self.audioSession.setCategory(.playAndRecord, options: [.mixWithOthers, .defaultToSpeaker, .allowBluetoothA2DP])
            try self.audioSession.setActive(true)
        } catch {
            print("SoundManager: 오디오 세션 설정 중 에러 발생 - \(error)")
            return nil
        }
        
        // 재생시킬 노드를 미리 엔진에 연결
        self.setupAudioNodes()
        
        // SoundType에 따라 configureSoundPlayers 구성
        self.setSoundType()
        
        // 더미 노드 생성 및 연결
        let dummyNode = AVAudioPlayerNode()
        self.engine.attach(dummyNode)
        self.engine.connect(dummyNode, to: self.engine.mainMixerNode, format: nil)
        
        // 엔진 시작
        self.audioEngineStart()
        
        // 더미 노드 분리
        self.engine.detach(dummyNode)
        
        // 전화 송/수신 시 interrupt 여부를 감지를 위한 notificationCenter 생성
        self.setupNotifications()
    }
    
    private func setupAudioNodes() {
        for _ in 0..<10 {
            let playerNode = AVAudioPlayerNode()
            self.playerNodePool.append(playerNode)
            self.engine.attach(playerNode)
            self.engine.connect(playerNode, to: self.engine.mainMixerNode, format: nil)
        }
    }
    
    @objc private func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        switch type {
        case .began:
            self.publisher.send()
            self.engine.stop()
            
        case .ended:
            self.audioEngineStart()
        default: ()
        }
    }
    
    private func setupNotifications() {
        let callInterruptNotificationCenter = NotificationCenter.default
        callInterruptNotificationCenter.addObserver(self,
                                                    selector: #selector(handleInterruption),
                                                    name: AVAudioSession.interruptionNotification,
                                                    object: self.audioSession
        )
    }
    
    private func configureSoundPlayers(soundType: SoundType) throws {
        let weakFileName: String = soundType.fileName + "_weak"
        let mediumFileName: String = soundType.fileName + "_medium"
        let strongFileName: String = soundType.fileName + "_strong"
        
        // 오디오 파일을 로드하고, AVAudioPCMBuffer로 변환하여 저장
        guard let weakBuffer = try? loadAudioFile(weakFileName),
              let mediumBuffer = try? loadAudioFile(mediumFileName),
              let strongBuffer = try? loadAudioFile(strongFileName) else {
            throw InitializeError.soundPlayerCreationFailed
        }
        
        self.audioBuffers[.weak] = weakBuffer
        self.audioBuffers[.medium] = mediumBuffer
        self.audioBuffers[.strong] = strongBuffer
    }
    
    private func loadAudioFile(_ resource: String) throws -> AVAudioPCMBuffer {
        guard let fileURL = Bundle.main.url(forResource: resource, withExtension: "wav") else {
            throw InitializeError.soundPlayerCreationFailed
        }
        
        let audioFile = try AVAudioFile(forReading: fileURL)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: AVAudioFrameCount(audioFile.length)) else {
            throw InitializeError.soundPlayerCreationFailed
        }
        
        try audioFile.read(into: buffer)
        return buffer
    }
    
    enum InitializeError: Error {
        case soundPlayerCreationFailed
    }
}

extension SoundManager: PlaySoundInterface {
    
    var callInterruptPublisher: AnyPublisher<Void, Never> {
        publisher.eraseToAnyPublisher()
    }
    
    func audioEngineStart() {
        if !self.engine.isRunning {
            do {
                try self.engine.start()
            } catch {
                print("오디오 엔진 시작 및 재시작 실패: \(error.localizedDescription)")
            }
        }
        self.engine.prepare()
        lastBeepTime = nil
    }

    func beep(_ accent: Accent) {
        let currentTime = CFAbsoluteTimeGetCurrent()
        if let lastTime = self.lastBeepTime {
            let interval = currentTime - lastTime
            logger.log("Beep interval: \(String(format: "%.4f", interval)) seconds")
        }
        lastBeepTime = currentTime
        
        guard let buffer = self.audioBuffers[accent] else { return }
        
        let playerNode = self.playerNodePool[self.poolIndex]
        self.poolIndex += 1
        self.poolIndex %= 10
        
        playerNode.scheduleBuffer(buffer, at: nil, options: .interrupts)
        playerNode.play()
    }
    
    func setSoundType() {
        self.soundType = self.appState.selectedSound
        
        do {
            try self.configureSoundPlayers(soundType: self.soundType)
        } catch {
            print("SoundManager: Sound Type 변경 실패 - \(error)")
        }
    }
}
