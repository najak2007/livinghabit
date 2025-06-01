//
//  ToDoListView.swift
//  livinghabit
//
//  Created by 오션블루 on 4/21/25.
//

import SwiftUI
import RealmSwift

struct ToDoListView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel = ToDoListViewModel()
    
    @FocusState private var focusedField: Bool
    
    @State private var toDoList: String = ""
    @State private var showingCustomAlert = false
    @State private var selectedToDoListData: ToDoListData?
    @State private var editedToDoList: String = ""
    @State private var addToggleState: Bool = false
    
    var body: some View {
        VStack (spacing: 0) {
            HorizontalListView()
                .padding(.top, 45)
                .padding(.horizontal, 10)
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
                            .font(.custom("AppleSDGothicNeo-Medium", size: 18 ))
                            .foregroundColor(colorScheme == .dark ? Color(hex: "#FFFFFF") : Color(hex: "#000000"))
                        Text("\(ToDoListData.date)")
                            .font(.custom("AppleSDGothicNeo-Regular", size: 15 ))
                            .foregroundColor(colorScheme == .dark ? Color(hex: "#FFFFFF") : Color(hex: "#000000"))
                    }
                    .onTapGesture {
                        
                        self.endTextEditing()
                        
                        selectedToDoListData = ToDoListData
                        editedToDoList = ToDoListData.toDoList
                        showingCustomAlert = true
                    }
                }
                .onDelete(perform: viewModel.deleteToDoList)
            }.environment(\.defaultMinListRowHeight, 70)
        }
        .overlay {
            VStack {
                HStack {
                    Spacer()

                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image("talk_close")
                    })
                }
                .padding(.horizontal, 10)
                .padding(.vertical , 0)
                .background(Color.clear)

                Spacer()
            }
        }
        .sheet(isPresented: $showingCustomAlert) {
            CustomAlertView(originalStr: $editedToDoList, title: "수정", message: "할 일을 입력하세요.", LButtonTitle: "취소", RButtonTitle: "수정", onSave: { isResult in
                if isResult.isEmpty == false, let selectedToDoListData = selectedToDoListData {
                    viewModel.updateToDoList(toDoListData: selectedToDoListData, newToDoList: editedToDoList)
                }
                showingCustomAlert = false
            })
            .clearModalBackground()
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
