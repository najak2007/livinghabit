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
    @State private var locationViewModel = LocationViewModel()
    @State private var isLocationDataUpdate: Bool = false
    
    @FocusState private var focusedField: Bool
    
    @State private var toDoList: String = ""
    @State private var showingCustomAlert = false
    @State private var selectedToDoListData: ToDoListData?
    @State private var editedToDoList: String = ""
    @State private var addToggleState: Bool = false
    @State private var placeSectionHeadList: [UserPlaceInfoData] = []
    
    var body: some View {
        VStack (spacing: 0) {
            HorizontalListView(locationViewModel: $locationViewModel, isLocationDataUpdate: $isLocationDataUpdate)
                .padding(.top, 35)
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
                        toDoListData.placeInfoData = fetchToSelectedPlaceData()
                        viewModel.saveToDoList(toDoListData)
                        toDoList = ""
                    }
            }
            .background(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue.opacity(0.8), lineWidth: focusedField == false ? 0 : 1)
                .fill(Color.gray.opacity(0.2) ))
            .padding(.horizontal, 10)
            .padding(.top, 5)
            
            List {
                ForEach(placeSectionHeadList, id: \.id) { placeInfoData in
                    if fecthToSectionData(placeInfoData.alias) == true {
                        Section(header: Text(placeInfoData.alias)) {
                            ForEach(viewModel.toDoLists, id: \.id) { ToDoListData in
                                VStack(alignment: .leading) {
                                    Text(ToDoListData.toDoList)
                                        .font(.custom("AppleSDGothicNeo-Medium", size: 18 ))
                                        .foregroundColor(colorScheme == .dark ? Color(hex: "#FFFFFF") : Color(hex: "#000000"))
#if false
                                    Text("\(ToDoListData.date)")
                                        .font(.custom("AppleSDGothicNeo-Regular", size: 15 ))
                                        .foregroundColor(colorScheme == .dark ? Color(hex: "#FFFFFF") : Color(hex: "#000000"))
#endif
                                }
                                .onTapGesture {
                                    
                                    self.endTextEditing()
                                    
                                    selectedToDoListData = ToDoListData
                                    editedToDoList = ToDoListData.toDoList
                                    showingCustomAlert = true
                                }
                            }
                            .onDelete(perform: viewModel.deleteToDoList)
                        }
                    }
                }
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
        .task {
            if isLocationDataUpdate {
                placeSectionHeadList = locationViewModel.locationLists
                isLocationDataUpdate = false
            }
        }
        
        .onAppear {
            placeSectionHeadList = locationViewModel.locationLists
        }
    }
    
    func getToDoListDataID() -> String {
        let date: Date = Date()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let nowID: String = dateFormatter.string(from: date)
        return nowID
    }
    
    func fecthToSectionData(_ sectionName: String) -> Bool {
        let sectionDataList = viewModel.toDoLists.filter({$0.placeInfoData?.alias == sectionName})
        
        if sectionDataList.count > 0 {
            return true
        }
        return false
        
    }
    
    func fetchToSelectedPlaceData() -> UserPlaceInfoData? {
        return locationViewModel.locationLists.filter({$0.isSelected == true}).first
    }
}
