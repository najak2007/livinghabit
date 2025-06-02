//
//  CustomAlertView.swift
//  livinghabit
//
//  Created by najak on 6/2/25.
//

import Foundation
import SwiftUI

struct CustomAlertView: View {
    @Binding var originalStr: String
    var title: String
    var message: String
    var LButtonTitle: String = "취소"
    var RButtonTitle: String = "수정"
    var onSave: (String) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("⌈\(title)⌋")
                .font(.custom("AppleSDGothicNeo-Bold", size: 25))
                .foregroundColor(Color(hex: "#000000"))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("\(message)", text: $originalStr)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Button(action: {
                    onSave("")
                }, label: {
                    Text("\(LButtonTitle)")
                        .font(.custom("AppleSDGothicNeo-Medium", size: 20))
                        .foregroundColor(Color(hex: "#000000"))
                })
                .frame(maxWidth: .infinity)
                
                Button(action: {
                    onSave(originalStr)
                }, label: {
                    Text("\(RButtonTitle)")
                        .font(.custom("AppleSDGothicNeo-Medium", size: 20))
                        .foregroundColor(Color(hex: "#000000"))
                })
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
        .frame(maxWidth: UIScreen.main.bounds.width - 40, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
    }
}
