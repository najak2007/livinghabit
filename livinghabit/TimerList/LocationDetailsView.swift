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
        TimelineView(.animation) { context in
            VStack {
                AnalogClock(
                    time: context.date,
                    location: location)
                Spacer()
            }
        }
    }
}

