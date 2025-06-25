//
//  LocationDetailsView.swift
//  livinghabit
//
//  Created by 오션블루 on 6/10/25.
//

import SwiftUI

struct LocationDetailsView: View {
    var location: ClockLocation
    @State private var showSeconds = true
    @State private var isToDoListShow = false
    
    func timeInLocalTimeZone(_ date: Date, showSeconds: Bool) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        
        if showSeconds {
            formatter.timeStyle = .medium
        } else {
            formatter.timeStyle = .short
        }
        formatter.timeZone = location.timeZone
        return formatter.string(from: date)
    }

    var body: some View {
        Button(action: {
            self.isToDoListShow.toggle()
        }, label: {
            TimelineView(.animation) { context in
                AnalogClock(
                    time: context.date,
                    location: location)
            }
        })
        .buttonStyle(.borderless)
        .fullScreenCover(isPresented: $isToDoListShow) {
            ToDoListView(date: Date(), location: location)
        }
        
        
//        TimelineView(.animation) { context in
//            AnalogClock(
//                time: context.date,
//                location: location)
//        }
    }
}

