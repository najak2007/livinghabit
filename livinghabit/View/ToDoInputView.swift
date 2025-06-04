//
//  ToDoInputView.swift
//  livinghabit
//
//  Created by najak on 6/3/25.
//

import Foundation
import SwiftUI

struct ToDoInputView: View {
    
    @State var inputText: String = ""
    @FocusState private var focusedField: Bool
    var inputHandler: (String) -> Void
    
    var body: some View {
        HStack {
            if !inputText.isEmpty {
                Button(action: {
                    
                }, label: {
                    Text("⚪️")
                        .font(.custom("AppleSDGothicNeo-Medium", size: 24))
                })
            }

            HStack {
                TextField("무엇을 할까?", text: $inputText)
                    .padding(.leading, inputText.isEmpty ? 8 : 2)
                    .focused($focusedField)
                    .font(.custom("AppleSDGothicNeo-Medium", size: 18))
                    .frame(height: 45)
                    .submitLabel(.done)
                    .onSubmit {
                        self.inputHandler(self.inputText)
                        inputText = ""
                    }
            }
            .background(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue.opacity(0.8), lineWidth: focusedField == false ? 0 : 1)
                .fill(inputText.isEmpty == false ? Color.clear : Color.gray.opacity(0.2) ))
        }
    }
}
