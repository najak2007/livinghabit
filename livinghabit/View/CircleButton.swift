//
//  CircleButton.swift
//  livinghabit
//
//  Created by najak on 6/11/25.
//

import SwiftUI

struct CircleButton: View {
    var title: String
    var size: CGFloat = 100
    var fontSize: CGFloat = 24
    var backgroundColor: Color = Color(hex: "#222222")
    var foregroundColor: Color = .white
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(backgroundColor)
                .frame(width: size, height: size)
                .overlay(
                    Text(title)
                        .font(.custom("AppleSDGothicNeo-Bold", size: fontSize))
                        .foregroundColor(foregroundColor)
                )
        }
    }
}
