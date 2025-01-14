//
//  SoundManager.swift
//  Macro
//
//  Created by Yunki on 10/3/24.
//

import SwiftUI
import AVFoundation

class SoundManager {
    
    private var appState: AppState
    
    private var engine: AVAudioEngine
    private var audioBuffers: [Accent: AVAudioPCMBuffer] = [:]
    private let audioSession = AVAudioSession.sharedInstance()
    private var soundType: SoundType
    
    init?(appState: AppState) {
        self.appState = appState
        self.soundType = .beep
        self.engine = AVAudioEngine()
        
        // AudioSession 설정
        do {
            try self.audioSession.setCategory(.playback, options: [.mixWithOthers, .allowBluetoothA2DP])
            try self.audioSession.setActive(true)
        } catch {
            print("SoundManager: 오디오 세션 설정 중 에러 발생 - \(error)")
            return nil
        }
        
        // SoundType에 따라 configureSoundPlayers 구성
        self.setSoundType()
        
        // 더미 노드 생성 및 연결
        let dummyNode = AVAudioPlayerNode()
        self.engine.attach(dummyNode)
        self.engine.connect(dummyNode, to: self.engine.mainMixerNode, format: nil)
        
        // 엔진 시작
        do {
            try engine.start()
        } catch {
            print("SoundManager: 오디오 엔진 시작 중 에러 발생 - \(error)")
            return nil
        }
        
        // 더미 노드 분리
        self.engine.detach(dummyNode)
    }
    
    private func configureSoundPlayers(weak: String, medium: String, strong: String) throws {
        // 오디오 파일을 로드하고, AVAudioPCMBuffer로 변환하여 저장
        guard let weakBuffer = try? loadAudioFile(weak),
              let mediumBuffer = try? loadAudioFile(medium),
              let strongBuffer = try? loadAudioFile(strong) else {
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
    
    func beep(_ accent: Accent) {
        
        guard let buffer = self.audioBuffers[accent] else { return }
        
        // 각 강세별 PlayerNode를 동적으로 생성하여 재생
        let playerNode = AVAudioPlayerNode()
        self.engine.attach(playerNode)
        
        let mainMixer = self.engine.mainMixerNode
        self.engine.connect(playerNode, to: mainMixer, format: nil)
        
        playerNode.scheduleBuffer(buffer, at: nil, options: .interrupts)
        playerNode.play()
        
        // 버퍼의 길이 계산
        let bufferLength = Double(buffer.frameLength) / buffer.format.sampleRate
        
        // 버퍼의 길이만큼 지난 후 playerNode 분리
        DispatchQueue.main.asyncAfter(deadline: .now() + bufferLength + 1) { [weak self] in
            guard let self = self else { return }
            self.engine.detach(playerNode)
        }
    }
    
    func setSoundType() {
        if self.appState.isBeepSound {
            self.soundType = .beep
        } else {
            switch self.appState.selectedInstrument {
            case .북:
                self.soundType = .buk
            case .장구:
                self.soundType = .jangu
            }
        }
        do {
            try self.configureSoundPlayers(weak: "\(self.soundType.rawValue)_weak", medium: "\(self.soundType.rawValue)_medium", strong: "\(self.soundType.rawValue)_strong")
        } catch {
            print("SoundManager: Sound Type 변경 실패 - \(error)")
        }
    }
}
