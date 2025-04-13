//
//  TemplateImplement.swift
//  Macro
//
//  Created by Lee Wonsun on 10/3/24.
//

import Combine

class TemplateImplement {
    // 장단의 정보를 저장하고 있는 레이어
    private var jangdanRepository: JangdanRepository
    
    private var currentJangdanTypeSubject: PassthroughSubject<Jangdan, Never>
    private var cancelBag: Set<AnyCancellable> = []
    
    init(jangdanRepository: JangdanRepository) {
        self.jangdanRepository = jangdanRepository
        
        self.currentJangdanTypeSubject = .init()
        
        self.jangdanRepository.jangdanPublisher.sink { [weak self] jangdan in
            guard let self else { return }
            self.currentJangdanTypeSubject.send(jangdan.jangdanType)
        }
        .store(in: &self.cancelBag)
    }
    
    enum DataError: Error {
        case registedName
    }
}

extension TemplateImplement: TemplateUseCase {
    var currentJangdanTypePublisher: AnyPublisher<Jangdan, Never> {
        return self.currentJangdanTypeSubject.eraseToAnyPublisher()
    }
    
    var allCustomJangdanTemplate: [JangdanEntity] {
        return jangdanRepository.fetchAllCustomJangdan()
    }
    
    func setJangdan(jangdanName: String) {
        self.jangdanRepository.fetchJangdanData(jangdanName: jangdanName)
    }
    
    // MARK: - Custom Template CRUD Logic
    func createCustomJangdan(newJangdanName: String) throws {
        guard !self.jangdanRepository.isRepeatedName(jangdanName: newJangdanName) else {
            throw DataError.registedName
        }
        self.jangdanRepository.saveNewJangdan(newJangdanName: newJangdanName)
    }
    
    func updateCustomJangdan(newJangdanName: String?) throws {
        if let newJangdanName, self.jangdanRepository.isRepeatedName(jangdanName: newJangdanName) {
            throw DataError.registedName
        }
        self.jangdanRepository.updateCustomJangdan(newJangdanName: newJangdanName)
    }
    
    func deleteCustomJangdan(jangdanName: String) {
        self.jangdanRepository.deleteCustomJangdan(jangdanName: jangdanName)
    }
}
