//
//  DynamicIconImplement.swift
//  Macro
//
//  Created by Yunki on 1/6/25.
//

import UIKit.UIApplication

class DynamicIconImplement {
    
}

extension DynamicIconImplement: DynamicIconUseCase {
    func setEventIconIfNeeded() {
        UIApplication.shared.setAlternateIconName("TestIcon")
    }
}
