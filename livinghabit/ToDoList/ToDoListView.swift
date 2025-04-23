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
    @State private var toDoListData = ToDoListData()
    @State private var toDoList: String = ""
    @State private var showingCustomAlert = false
    @State private var selectedToDoListData: ToDoListData?
    @State private var editedToDoList: String = ""
    
    var body: some View {
        VStack {
            TextField("할 일을 입력하세요", text: $toDoList)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
            Button("저장") {
                toDoListData.toDoList = toDoList
                viewModel.saveToDoList(toDoListData)
            }
            .padding()
            
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
        }
        .sheet(isPresented: $showingCustomAlert) {
            CustomAlertView(toDoList: $editedToDoList, onSave: {
                if let selectedToDoListData = selectedToDoListData {
                    viewModel.updateToDoList(toDoListData: selectedToDoListData, newToDoList: editedToDoList)
                }
                showingCustomAlert = false
            })
        }
    }
}

struct CustomAlertView: View {
    @Binding var toDoList: String
    var onSave: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("수정")
                .font(.headline)
            
            TextField("할 일을 입력하세요", text: $toDoList)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Button("취소") {
                    onSave()
                }
                .padding()
                
                Button("저장") {
                    onSave()
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
