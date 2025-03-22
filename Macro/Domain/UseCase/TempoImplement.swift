//
//  TempoImplement.swift
//  Macro
//
//  Created by Lee Wonsun on 10/3/24.
//

import Combine
import Foundation

class TempoImplement {
    private var jangdanRepository: JangdanRepository
    
    static let minBPM: Int = 10
    static let maxBPM: Int = 300
    
    /// 마지막 tap 시점으로부터 6초가 지났을 때 이벤트를 전달하기 위한 publisher
    @Published private var lastTappedDate: Date?
    private var isTappingSubject: PassthroughSubject<Bool, Never>
    private var isTapping: Bool
    private var timeStampList: [Date]
    
    private var cancelBag: Set<AnyCancellable>
    
    init(jangdanRepository: JangdanRepository) {
        self.jangdanRepository = jangdanRepository
        
        self.isTappingSubject = .init()
        self.isTapping = false
        self.timeStampList = .init()
        
        self.cancelBag = .init()
        
        $lastTappedDate
            .debounce(for: .seconds(6), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.finishTapping()
                self.isTappingSubject.send(self.isTapping)
            }
            .store(in: &cancelBag)
    }
}

extension TempoImplement: TempoUseCase {
    func updateTempo(newBpm: Int) {
        // 사용자가 변경한 BPM을 각 장단별 데이터 객체에 저장 요청
        switch newBpm {
        case ..<Self.minBPM:
            self.jangdanRepository.updateBPM(bpm: Self.minBPM)
        case Self.minBPM...Self.maxBPM:
            self.jangdanRepository.updateBPM(bpm: newBpm)
        case Self.maxBPM...:
            self.jangdanRepository.updateBPM(bpm: Self.maxBPM)
        default :
            break
        }
    }
    
    var isTappingPublisher: AnyPublisher<Bool, Never> {
        self.isTappingSubject.eraseToAnyPublisher()
    }
    
    func tap(timeStamp: Date) {
        if !isTapping {
            isTapping = true
            self.isTappingSubject.send(self.isTapping)
        }
        
        lastTappedDate = timeStamp
        self.timeStampList.append(timeStamp)
        
        if timeStampList.count > 5 {
            self.timeStampList.removeFirst()
        }
        
        guard timeStampList.count > 1 else { return }
        
        let interval: TimeInterval = timeStampList.last!.timeIntervalSince(timeStampList.first!)
        let averageInterval: TimeInterval = interval / Double(timeStampList.count - 1)
        let tempo: Double = 60 / averageInterval
        self.updateTempo(newBpm: Int(tempo.rounded()))
    }
    
    func finishTapping() {
        self.isTapping = false
        self.isTappingSubject.send(self.isTapping)
        self.timeStampList.removeAll()
    }
}
