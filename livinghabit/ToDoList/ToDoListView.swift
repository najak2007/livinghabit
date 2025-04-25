//
//  ToDoListView.swift
//  livinghabit
//
//  Created by 오션블루 on 4/21/25.
//

import SwiftUI
import RealmSwift

struct ToDoListView: View {
    @StateObject private var viewModel = ToDoListViewModel()
    @FocusState private var focusedField: Bool
    
    @State private var toDoList: String = ""
    @State private var showingCustomAlert = false
    @State private var selectedToDoListData: ToDoListData?
    @State private var editedToDoList: String = ""
    
    var body: some View {
        VStack (spacing: 20) {
            HStack {
                TextField("무엇을 할까?", text: $toDoList)
                    .padding()
                    .focused($focusedField)
                    .font(.custom("AppleSDGothicNeo-Medium", size: 18))
                    .frame(height: 45)
                    .submitLabel(.done)
                    .onSubmit {
                        let toDoListData = ToDoListData()
                        toDoListData.toDoList = self.toDoList
                        toDoListData.id = self.getToDoListDataID()
                        viewModel.saveToDoList(toDoListData)
                        toDoList = ""
                    }
            }
            .background(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue.opacity(0.8), lineWidth: focusedField == false ? 0 : 1)
                .fill(Color.gray.opacity(0.2) ))
            .padding(.horizontal, 10)
            .padding(.top, 10)
            
            List {
                ForEach(viewModel.toDoLists, id: \.id) { ToDoListData in
                    VStack(alignment: .leading) {
                        Text(ToDoListData.toDoList)
                        Text("\(ToDoListData.date)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .onTapGesture {
                        selectedToDoListData = ToDoListData
                        editedToDoList = ToDoListData.toDoList
                        showingCustomAlert = true
                    }
                }
                .onDelete(perform: viewModel.deleteToDoList)
            }
            .onTapGesture {
                self.endTextEditing()
            }
        }
        .sheet(isPresented: $showingCustomAlert) {
            CustomAlertView(toDoList: $editedToDoList, onSave: { isResult in
                if isResult, let selectedToDoListData = selectedToDoListData {
                    viewModel.updateToDoList(toDoListData: selectedToDoListData, newToDoList: editedToDoList)
                }
                showingCustomAlert = false
            })
        }
    }
    
    func getToDoListDataID() -> String {
        let date: Date = Date()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let nowID: String = dateFormatter.string(from: date)
        return nowID
    }
}

struct CustomAlertView: View {
    @Binding var toDoList: String
    var onSave: (Bool) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("수정")
                .font(.headline)
            
            TextField("할 일을 입력하세요", text: $toDoList)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Button("취소") {
                    onSave(false)
                }
                .padding()
                
                Button("저장") {
                    onSave(true)
                }
                .padding()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.4).edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    ToDoListView()
        
}
