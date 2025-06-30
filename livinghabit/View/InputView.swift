//
//  InputView.swift
//  livinghabit
//
//  Created by najak on 6/3/25.
//

import Foundation
import SwiftUI

struct InputView: View {
    
    @State var inputText: String = ""
    var originalText: String = ""
    @FocusState private var focusedField: Bool
    var inputHandler: (String) -> Void
    var selectHandler: ((Bool) -> Void)? = nil
    var image: Image? = nil
    
    var body: some View {
        HStack {
            if inputText.isEmpty == false, let selectHandler = selectHandler {
                Button(action: {
                    self.selectHandler?(true)
                }, label: {
                    Text("⚪️")
                        .font(.custom("AppleSDGothicNeo-Medium", size: 24))
                })
            } 

            HStack {
                TextField("", text: $inputText)
                    .padding(.leading, inputText.isEmpty ? 8 : 2)
                    .focused($focusedField)
                    .font(.custom("AppleSDGothicNeo-Medium", size: 18))
                    .frame(height: 45)
                    .submitLabel(.done)
                    .onSubmit {
                        let trimWhiteSpace = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
                        self.inputText = trimWhiteSpace
                        
                        if inputText.isEmpty { return }
                        if inputText == originalText { return }
                        self.inputHandler(self.inputText)
                        
                        if originalText.isEmpty {
                            self.inputText = ""
                        }
                    }
                
                if inputText.isEmpty == false, image != nil {
                    Image(systemName: "camera.circle.fill")
                }
            }
            .background(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue.opacity(0.8), lineWidth: focusedField == false ? 0 : 1)
                .fill(inputText.isEmpty == false ? Color.clear : Color.gray.opacity(0.2) ))
        }
    }
}
