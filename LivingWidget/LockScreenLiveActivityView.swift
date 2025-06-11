//
//  LockScreenLiveActivityView.swift
//  livinghabit
//
//  Created by najak on 6/11/25.
//

import SwiftUI
import ActivityKit
import WidgetKit


struct LockScreenLiveActivityView: View {
    let context: ActivityViewContext<LivingWidgetAttributes>
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    
    var body: some View {
        if isLuminanceReduced {
            VStack(spacing: -3) {
                Spacer(minLength: 14)
                Text("\(context.state.taskName)")
                    .foregroundColor(.white.opacity(0.5))
                Text(timerInterval: context.state.timer, countsDown: context.attributes.isTimer)
                    .multilineTextAlignment(.center)
                    .monospacedDigit()
                    .font(.system(size: 44, weight: .semibold))
                    .foregroundColor(color(context: context).opacity(0.5))
                Spacer()
            }
            .background(.black.opacity(0.6))
        } else {
            VStack(spacing: -3) {
                Spacer(minLength: 14)
                Text("\(context.state.taskName)")
                    .foregroundColor(.white)
                Text(timerInterval: context.state.timer, countsDown: context.attributes.isTimer)
                    .multilineTextAlignment(.center)
                    .monospacedDigit()
                    .font(.system(size: 44, weight: .semibold))
                    .foregroundColor(color(context: context))
                Spacer()
            }
            .background(.black.opacity(0.6))
        }
    }
    
    func color(context: ActivityViewContext<LivingWidgetAttributes>) -> Color {
#if true
        return Color.white
#else
        if let color = UserDefaults.colorForKey(key: context.attributes.isTimer ? .timerBackground : .stopwatchBackground) {
            return Color(color)
        } else {
            return Color(UIColor(named: context.attributes.isTimer ? "Background" : "Background2")!)
        }
#endif
    }
}
