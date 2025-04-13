//
//  TemplateUseCase.swift
//  Macro
//
//  Created by leejina on 11/8/24.
//

import Combine

protocol TemplateUseCase {
    var currentJangdanTypePublisher: AnyPublisher<Jangdan, Never> { get }
    
    var allCustomJangdanTemplate: [JangdanEntity] { get }
    
    func setJangdan(jangdanName: String)
    
    func createCustomJangdan(newJangdanName: String) throws
    
    func updateCustomJangdan(newJangdanName: String?) throws
    
    func deleteCustomJangdan(jangdanName: String)
}
