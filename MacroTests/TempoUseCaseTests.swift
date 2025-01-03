//
//  MacroTests.swift
//  MacroTests
//
//  Created by Yunki on 9/21/24.
//

import Testing
@testable import Macro

struct MacroTest {
    @Test("test example")
    func testExample() throws {
        #expect(true)
    }
}
