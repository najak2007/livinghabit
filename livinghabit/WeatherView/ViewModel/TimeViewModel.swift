//
//  TimeViewModel.swift
//  livinghabit
//
//  Created by 오션블루 on 5/7/25.
//

import SwiftUI
import Foundation

enum TimeCondition: String, Hashable, Decodable {
    case 새벽
    case 오전
    case 오후
    case 저녁
    case 밤

    var currentHour: Int {
        set {
            self.currentHour = newValue
        }
        
        get {
            return self.currentHour
        }
    }
    
    var rawValue: String {
        get {
            if currentHour >= 0 && currentHour < 6 {
                return TimeCondition.새벽.rawValue
            } else if currentHour >= 6 && currentHour < 11 {
                return TimeCondition.오전.rawValue
            } else if currentHour >= 12 && currentHour < 19 {
                return TimeCondition.오후.rawValue
            } else if currentHour >= 20 && currentHour < 22 {
                return TimeCondition.저녁.rawValue
            }
            return TimeCondition.밤.rawValue
            
        }
    }
    
    init(_ currentHour: Int)  {
        self.currentHour = currentHour
    }
    
}

class TimeViewModel: ObservableObject {
    @Published var timeCondition: TimeCondition = .오전
    
    init() {}
    
    func getTimeCondition() -> String {
        
        let localTimeZone = TimeZone.current
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = localTimeZone
        
        let currentTimeString = formatter.string(from: Date())
        let currentTimeComponents = currentTimeString.split(separator: ":")
        let currentHour: Int = Int(currentTimeComponents[0]) ?? 0
        
        return TimeCondition(currentHour).rawValue
        
        return timeCondition.rawValue
    }
}
