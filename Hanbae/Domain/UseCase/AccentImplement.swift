//
//  AccentImplement.swift
//  Macro
//
//  Created by leejina on 10/7/24.
//

import Combine

class AccentImplement {
    private var jangdanRepository: JangdanRepository
    private var daebakList: [[JangdanEntity.Daebak]]
    
    private var accentListSubject: PassthroughSubject<[[[Accent]]], Never>
    private var cancelBag: Set<AnyCancellable> = []
    
    init(jangdanRepository: JangdanRepository) {
        self.jangdanRepository = jangdanRepository
        self.daebakList = []
        
        self.accentListSubject = .init()
        
        self.jangdanRepository.jangdanPublisher.sink { jangdanEntity in
            self.daebakList = jangdanEntity.daebakList
            
            let accentList: [[[Accent]]] = self.daebakList.map { $0.map { $0.bakAccentList } }
            self.accentListSubject.send(accentList)
        }
        .store(in: &cancelBag)
    }
}

extension AccentImplement: AccentUseCase {
    var accentListPublisher: AnyPublisher<[[[Accent]]], Never> {
        self.accentListSubject.eraseToAnyPublisher()
    }
    
    func moveNextAccent(rowIndex: Int, daebakIndex: Int, sobakIndex: Int, to newAccent: Accent) {
        self.daebakList[rowIndex][daebakIndex].bakAccentList[sobakIndex] = newAccent
        self.jangdanRepository.updateAccents(daebakList: self.daebakList)
    }
}
