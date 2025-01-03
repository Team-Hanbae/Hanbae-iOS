//
//  MacroTests.swift
//  MacroTests
//
//  Created by Yunki on 9/21/24.
//

//import Testing
//@testable import Macro
//
//class TemplateUseCaseStub: UpdateTempoInterface {
//    
//    var bpm: Int?
//    
//    func updateTempo(newBpm: Int) {
//        self.bpm = newBpm
//    }
//}
//
//@Suite("TempoUseCaseTests")
//struct TempoUseCaseTests {
//    // given
//    let templateUseCaseStub: TemplateUseCaseStub
//    let sut: TempoImplement
//    
//    init() {
//        self.templateUseCaseStub = TemplateUseCaseStub()
//        self.sut = TempoImplement(templateUseCase: templateUseCaseStub)
//    }
//
//    @Test("템포UC 정상범주", arguments: [
//        10, 11, 20, 30, 50, 100, 190, 200
//    ])
//    func updateTempoTest(newBPM: Int) {
//        // when
//        self.sut.updateTempo(newBpm: newBPM)
//        
//        // then
//        #expect(self.templateUseCaseStub.bpm == newBPM)
//    }
//    
//    @Test("템포UC 10미만", arguments: [
//        -100, -30, -1, 0, 1, 3, 7, 9
//    ])
//    func updateTempoUnder10Test(newBPM: Int) {
//        self.sut.updateTempo(newBpm: newBPM)
//        #expect(self.templateUseCaseStub.bpm == 10)
//    }
//    
//    @Test("템포UC 200초과", arguments: [
//        201, 202, Int.max
//    ])
//    func updateTempoOver200Test(newBPM: Int) {
//        self.sut.updateTempo(newBpm: newBPM)
//        #expect(self.templateUseCaseStub.bpm == 200)
//    }
//}
