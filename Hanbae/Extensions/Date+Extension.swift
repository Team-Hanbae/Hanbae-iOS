//
//  Date+Extension.swift
//  Macro
//
//  Created by Yunki on 11/21/24.
//

import Foundation

extension Date {
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = .autoupdatingCurrent
        formatter.timeZone = .current
        
        return formatter.string(from: self)
    }
    
    static func at(year: Int, month: Int, day: Int) -> Date? {
        let component = DateComponents(year: year, month: month, day: day)
        var calendar = Calendar.current
        calendar.timeZone = .current
        calendar.locale = .autoupdatingCurrent
        
        guard let date = calendar.date(from: component) else { return nil }
        
        return date
    }
}
