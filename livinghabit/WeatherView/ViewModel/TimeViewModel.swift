//
//  TimeViewModel.swift
//  livinghabit
//
//  Created by 오션블루 on 5/7/25.
//

import SwiftUI
import Foundation


enum Hourly: String, Hashable, Decodable {
    case 새벽
    case 오전
    case 오후
    case 저녁
    case 밤
    
    
    var emoji: String {
        switch self {
        case .새벽:
            return "🌙"
        case .오전:
            return "🌄"
        case .오후:
            return "☀️"
        case .저녁:
            return "🌅"
        case .밤:
            return "🌚"
        }
    }
}

struct TimeRange {

    var currentHour: Int = 0
    
    init(_ hour: Int) {
        self.currentHour = hour
    }
    
    var hourly: Hourly {
        get {
            if currentHour >= 0 && currentHour < 6 {
                return .새벽
            } else if currentHour >= 6 && currentHour < 11 {
                return .오전
            } else if currentHour >= 12 && currentHour < 19 {
                return .오후
            } else if currentHour >= 20 && currentHour < 22 {
                return .저녁
            }
            return .밤
        }
        set {
        }
    }
}

class TimeViewModel: ObservableObject {
     init() {}
    
    func getTimeCondition() -> String {
        let localTimeZone = TimeZone.current
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = localTimeZone
        
        let currentTimeString = formatter.string(from: Date())
        let currentTimeComponents = currentTimeString.split(separator: ":")
        let currentHour: Int = Int(currentTimeComponents[0]) ?? 0
        return TimeRange(currentHour).hourly.emoji
    }
}
