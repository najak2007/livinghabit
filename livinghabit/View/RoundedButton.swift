//
//  RoundedButton.swift
//  livinghabit
//
//  Created by najak on 6/11/25.
//

import SwiftUI

struct RoundedButton: View {
    var title: String
    var fontSize: CGFloat = 18
    var backgroundColor: Color = Color(hex: "#E6F4E1")
    var foregroundColor: Color = Color(hex: "#222222")
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .font(.custom("AppleSDGothicNeo-Medium", size: fontSize))
                .background(backgroundColor)                    // 배경색 설정
                .foregroundStyle(foregroundColor)               // 글자 색상 설정
                .cornerRadius(10)                                 // 라운딩 적용
        }
    }
}
