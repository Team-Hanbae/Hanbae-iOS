//
//  TempoImplement.swift
//  Macro
//
//  Created by Lee Wonsun on 10/3/24.
//

import Foundation

class TempoImplement {
    private var jangdanRepository: JangdanRepository
    
    init(jangdanRepository: JangdanRepository) {
        self.jangdanRepository = jangdanRepository
    }
}

extension TempoImplement: TempoUseCase {
    func updateTempo(newBpm: Int) {
        // 사용자가 변경한 BPM을 각 장단별 데이터 객체에 저장 요청
        switch newBpm {
        case ..<10:
            self.jangdanRepository.updateBPM(bpm: 10)
        case 10...200:
            self.jangdanRepository.updateBPM(bpm: newBpm)
        case 200...:
            self.jangdanRepository.updateBPM(bpm: 200)
        default :
            break
        }
    }
}
