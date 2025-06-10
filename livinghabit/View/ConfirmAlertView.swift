//
//  ConfirmAlertView.swift
//  livinghabit
//
//  Created by najak on 6/10/25.
//

import Foundation
import SwiftUI

struct ConfirmAlertView: View {
    var title: String
    var message: String
    var LButtonTitle: String = "취소"
    var RButtonTitle: String = "확인"
    var onSave: (Bool) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("\(title)")
                .font(.custom("AppleSDGothicNeo-Bold", size: 25))
                .foregroundColor(Color(hex: "#000000"))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(message)
                .font(.custom("AppleSDGothicNeo-Medium", size: 17))
                .foregroundColor(Color(hex: "#000000"))
                .frame(maxWidth: .infinity, alignment: .center)
            
            HStack {
                Button(action: {
                    onSave(false)
                }, label: {
                    Text("\(LButtonTitle)")
                        .font(.custom("AppleSDGothicNeo-Medium", size: 20))
                        .foregroundColor(Color(hex: "#000000"))
                })
                .frame(maxWidth: .infinity)
                
                Button(action: {
                    onSave(true)
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
