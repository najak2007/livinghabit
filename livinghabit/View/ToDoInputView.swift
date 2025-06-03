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
    
    var body: some View {
        HStack {
            Button(action: {
                
            }, label: {
                Text("⚪️")
                    .font(.custom("AppleSDGothicNeo-Medium", size: 24))
            })
            
            
            TextField("무엇을 할까?", text: $inputText)
                .padding()
                .focused($focusedField)
                .font(.custom("AppleSDGothicNeo-Medium", size: 18))
                .frame(height: 45)
                .submitLabel(.done)
                .onSubmit {
#if true
                    
#else
                    let toDoListData = ToDoListData()
                    toDoListData.toDoList = self.toDoList
                    toDoListData.id = self.getToDoListDataID()
                    toDoListData.placeInfoData = fetchToSelectedPlaceData()
                    viewModel.saveToDoList(toDoListData)
                    toDoList = ""
#endif
                }
        }
        .background(RoundedRectangle(cornerRadius: 10)
            .stroke(Color.blue.opacity(0.8), lineWidth: focusedField == false ? 0 : 1)
            .fill(Color.gray.opacity(0.2) ))
        .padding(.horizontal, 10)
        .padding(.top, 5)
    }
}
