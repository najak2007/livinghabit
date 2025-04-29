//
//  Date+Extension.swift
//  livinghabit
//
//  Created by 오션블루 on 4/28/25.
//

import Foundation
import SwiftUI

extension Date {
    public func dateCompare(fromDate: Date) -> String {
        let dateFormatter: DateFormatter = .init()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let fromDateString: String = dateFormatter.string(from: fromDate)
        let selfDateString: String = dateFormatter.string(from: self)
        
        if fromDateString == selfDateString {
            return "S"      // 동일
        } else if fromDateString > selfDateString {
            return "F"      // 미래
        } else if fromDateString < selfDateString {
            return "P"      // 과거
        }

        return ""
    }
}
