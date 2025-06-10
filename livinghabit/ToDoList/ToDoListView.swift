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
    
    @FocusState private var focusedField: Bool
    
    @State private var toDoList: String = ""
    @State private var showingCustomAlert = false
    @State private var selectedToDoListData: ToDoListData?
    @State private var editedToDoList: String = ""
    @State private var addToggleState: Bool = false
    @State private var placeSectionHeadList: [UserPlaceInfoData] = []
    @State private var leftButtonTitle: String = "Menu"
    @State private var toDoInputText: String = ""

    
    var body: some View {
        VStack (spacing: 0) {
            HorizontalListView(locationViewModel: $locationViewModel, locationUpdateHandler: { isUpdate in
                placeSectionHeadList = locationViewModel.locationLists
            }, updateLocationDataCompletion: { userPlaceInfoData, updateCoordinate2D in
                locationViewModel.updateLocationForCoordinate(userPlaceInfoData, editLatitude: updateCoordinate2D.latitude, editLongitude: updateCoordinate2D.longitude)
            })
                .padding(.top, 35)
                .padding(.horizontal, 10)
            
            List {
                ForEach(placeSectionHeadList, id: \.id) { placeInfoData in
                    Section(header: ToDoListHeader(headerTitle: placeInfoData.alias)) {
                        ForEach(viewModel.toDoLists, id: \.id) { ToDoListData in
                            if placeInfoData.id == ToDoListData.placeInfoData?.id {
                                HStack {
                                    VStack(alignment: .leading) {
                                        ToDoInputView(inputText: ToDoListData.toDoList, originalText: ToDoListData.toDoList, inputHandler: { inputText in
                                            if !inputText.isEmpty {
                                                viewModel.updateToDoList(toDoListData: ToDoListData, newToDoList: inputText)
                                            }
                                        }, selectHandler: { isSelected in
                                            viewModel.updateToDoListStatus(toDoListData: ToDoListData, isDone: isSelected)
                                        })
                                    }
                                    .onTapGesture {
                                        self.endTextEditing()
                                        
                                        selectedToDoListData = ToDoListData
                                        editedToDoList = ToDoListData.toDoList
                                        showingCustomAlert = true
                                    }
                                }
                            }
                        }
                        .onDelete(perform: viewModel.deleteToDoList)
                        .onMove(perform: viewModel.moveList)
                        
                        ToDoInputView(inputText: "", originalText: "", inputHandler: { inputText in
                            if !inputText.isEmpty {
                                let toDoListData = ToDoListData()
                                toDoListData.toDoList = inputText
                                toDoListData.placeInfoData = placeInfoData
                                viewModel.saveToDoList(toDoListData)
                            }
                        })
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
                .padding(.horizontal, 15)
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
        .onAppear {
            placeSectionHeadList = locationViewModel.locationLists
        }
        .background( Color.clear)
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
