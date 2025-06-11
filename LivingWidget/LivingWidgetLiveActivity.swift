//
//  LivingWidgetLiveActivity.swift
//  LivingWidget
//
//  Created by najak on 6/11/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct LivingWidgetAttributes: ActivityAttributes {
    public typealias titiStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        var taskName: String
        var timer: ClosedRange<Date>
    }
    
    var isTimer: Bool
}

struct LivingWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LivingWidgetAttributes.self) { context in
            LockScreenLiveActivityView(context: context)
        } dynamicIsland: { context in
            // Create the presentations that appear in the Dynamic Island.
            DynamicIsland {
                // Create the expanded presentation.
                DynamicIslandExpandedRegion(.center) {
                    Text("\(context.state.taskName)")
                        .lineLimit(1)
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    Text(timerInterval: context.state.timer, countsDown: context.attributes.isTimer)
                        .multilineTextAlignment(.center)
                        .monospacedDigit()
                        .font(.system(size: 44, weight: .semibold))
                        .foregroundColor(color(context: context))
                }
            } compactLeading: {
                Image("titiIcon")
                    .renderingMode(.template)
                    .colorMultiply(color(context: context))
            } compactTrailing: {
                Text(timerInterval: context.state.timer, countsDown: context.attributes.isTimer)
                    .monospacedDigit()
                    .frame(width: 50)
                    .font(.system(size: 12.7, weight: .semibold))
                    .foregroundColor(color(context: context))
            } minimal: {
                Image("titiIcon")
                    .renderingMode(.template)
                    .colorMultiply(color(context: context))
            }
            .contentMargins(.all, 8, for: .expanded)
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


