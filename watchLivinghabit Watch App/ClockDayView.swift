//
//  ClockDayView.swift
//  livinghabit
//
//  Created by 오션블루 on 6/10/25.
//

import SwiftUI

struct ClockDayView: View {
    var time: Date
    var location: ClockLocation

    var dayOfMonth: Int {
        let dateComponents = Calendar.current.dateComponents(in: location.timeZone, from: time)
        return dateComponents.day ?? 1
    }

    var body: some View {
        Text("\(dayOfMonth)")
            .foregroundColor(.black)
            .background(.white)
            .padding(4)
            .overlay(
                RoundedRectangle(cornerRadius: 5.0)
                    .stroke(.black))
    }
}

