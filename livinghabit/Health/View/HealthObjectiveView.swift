//
//  HealthObjectiveView.swift
//  livinghabit
//
//  Created by najak on 6/11/25.
//

import SwiftUI
import Foundation

enum Objective: String {
    case 거리
    case 걸음수
    case 시간
    
    var K: String {
        return rawValue
    }
}


struct HealthObjectiveView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var selectedObjectiveHandler: ((Objective) -> Void)
    
    var body: some View {
        List {
            Button(action: {
                selectedObjectiveHandler(.거리)
            }, label: {
                Text(Objective.거리.K)
                    .font(.custom("AppleSDGothicNeo-Medium", size: 19))
                    .foregroundColor(colorScheme == .dark ?  Color(hex: "#FFFFFF") : Color(hex: "#000000"))
            })
            
            Button(action: {
                selectedObjectiveHandler(.걸음수)
            }, label: {
                Text(Objective.걸음수.K)
                    .font(.custom("AppleSDGothicNeo-Medium", size: 19))
                    .foregroundColor(colorScheme == .dark ?  Color(hex: "#FFFFFF") : Color(hex: "#000000"))
            })
            
            Button(action: {
                selectedObjectiveHandler(.시간)
            }, label: {
                Text(Objective.시간.K)
                    .font(.custom("AppleSDGothicNeo-Medium", size: 19))
                    .foregroundColor(colorScheme == .dark ?  Color(hex: "#FFFFFF") : Color(hex: "#000000"))
            })
            
        }
        .environment(\.defaultMinListRowHeight, 70)
        .scrollDisabled(true)
    }
}
