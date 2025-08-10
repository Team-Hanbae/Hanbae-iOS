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
        let today = Date.now
        
        let start = Date.at(year: 2025, month: 1, day: 1)!
        let end = Date.at(year: 2025, month: 2, day: 6)!
        let 설날이벤트: ClosedRange<Date> = start...end
        
        switch today {
        case 설날이벤트:
            setIconWithoutAlert("NewYear")
        default:
            setIconWithoutAlert(nil)
        }
    }
    
    private func setIconWithoutAlert(_ iconName: String?) {
        guard UIApplication.shared.responds(to: #selector(getter: UIApplication.supportsAlternateIcons)) else { return }
        guard UIApplication.shared.supportsAlternateIcons else { return }
        guard UIApplication.shared.alternateIconName != iconName else { return }
        
        typealias setAlternateIconName = @convention(c) (NSObject, Selector, NSString?, @escaping (NSError) -> ()) -> ()
        let selectorString = "_setAlternateIconName:completionHandler:"
        let selector = NSSelectorFromString(selectorString)
        let imp = UIApplication.shared.method(for: selector)
        let method = unsafeBitCast(imp, to: setAlternateIconName.self)
        method(UIApplication.shared, selector, iconName as NSString?, { _ in })
    }
}
