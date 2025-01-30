//
//  TapTapImplement.swift
//  Macro
//
//  Created by Yunki on 10/28/24.
//

import Combine
import Foundation

class TapTapImplement {
    private var timeStampList: [Date] = []
    private var isTapping: Bool
    
    /// 마지막 tap 시점으로부터 6초가 지났을 때 이벤트를 전달하기 위한 publisher
    @Published private var lastTappedDate: Date?
    
    private var isTappingSubject = PassthroughSubject<Bool, Never>()
    
    private var cancelBag: Set<AnyCancellable> = []
    
    init() {
        self.isTapping = false
        self.timeStampList = []
        
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

// ViewModel에서 호출할 용도
extension TapTapImplement: TapTapUseCase {
    var isTappingPublisher: AnyPublisher<Bool, Never> {
        self.isTappingSubject.eraseToAnyPublisher()
    }
    
    func tap(timeStamp: Date = .now) -> Int? {
        if !isTapping {
            isTapping = true
            self.isTappingSubject.send(self.isTapping)
        }
        
        lastTappedDate = timeStamp
        self.timeStampList.append(timeStamp)
        
        if timeStampList.count > 5 {
            self.timeStampList.removeFirst()
        }
        
        guard timeStampList.count > 1 else { return nil }
        
        let interval: TimeInterval = timeStampList.last!.timeIntervalSince(timeStampList.first!)
        let averageInterval: TimeInterval = interval / Double(timeStampList.count - 1)
        let tempo: Double = 60 / averageInterval
        return Int(tempo.rounded())
    }
    
    func finishTapping() {
        self.isTapping = false
        self.isTappingSubject.send(self.isTapping)
        self.timeStampList.removeAll()
    }
}
