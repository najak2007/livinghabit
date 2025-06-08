//
//  HorizontalListView..swift
//  livinghabit
//
//  Created by 오션블루 on 5/30/25.
//

import Foundation
import SwiftUI

struct CustomItemView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var locationData: UserPlaceInfoData
    @Binding var addToggleState: Bool

    @State private var isLocationEdit: Bool = false
    @State private var isLocationNameState: Bool = false
    @State private var selectedUserPlaceInfoData: UserPlaceInfoData?
    @State private var editedLocationName: String = ""
    @State private var locationName: String = ""
    
    var updateCompletion: ((String?) -> Void)? = nil
    
    var body: some View {
        VStack {
            if locationData.isAddLocation == true {
                Button(action: {
                    addToggleState.toggle()
                }, label: {
                    Text(locationData.alias)
                        .padding()
                        .font(.custom("AppleSDGothicNeo-Medium", size: 20))
                        .foregroundColor(colorScheme == .dark ? Color(hex: "#FFFFFF") : Color(hex: "#000000"))
                        .frame(minWidth: 70, maxHeight: 40)
                })
            } else {
                Menu {
                    Button(action: {
                        selectedUserPlaceInfoData = locationData
                        isLocationEdit.toggle()
                    }, label: {
                        Text("📍 위치")
                          .padding()
                    })

                    Button(action: {
                        selectedUserPlaceInfoData = locationData
                        editedLocationName = locationData.alias
                        isLocationNameState.toggle()
                    }, label: {
                        Text("📝 수정")
                          .padding()
                    })
                    
                    Button(action: {
                        selectedUserPlaceInfoData = locationData
                        self.updateCompletion?(nil)
                    }, label: {
                        Text("⛔️ 삭제")
                          .padding()
                    })
                } label: {
                    Text(locationName)
                        .padding()
                        .font(.custom("AppleSDGothicNeo-Medium", size: 20))
                        .foregroundColor(colorScheme == .dark ? Color(hex: "#FFFFFF") : Color(hex: "#000000"))
                        .frame(minWidth: 70, maxHeight: 40)
                }

            }
        }
        .sheet(isPresented: $isLocationNameState) {
            CustomAlertView(originalStr: $editedLocationName, title: "수정", message: "장소 입력해 주세요.", LButtonTitle: "취소", RButtonTitle: "수정", onSave: { result in
                if result.isEmpty == false {
                    self.updateCompletion?(result)
                }
                isLocationNameState = false
            })
            .clearModalBackground()
        }
        .fullScreenCover(isPresented: $isLocationEdit, content: {
            MapView(isSearchTextField: true)
        })
        .onAppear {
            self.locationName = locationData.alias
        }
        .background(Color.gray.opacity(0.3))
        .cornerRadius(10)
        .padding(2)
    }
}

struct HorizontalListView: View {
    @Binding var locationViewModel: LocationViewModel
    
    @State private var locationLists: [UserPlaceInfoData] = []
    
    @State private var addToggle: Bool = false
    @State private var addLocationName: String = ""
    @State private var newLocationName: String = ""
    @State private var editId: String = ""

    var locationUpdateHandler: ((Bool) -> Void)? = nil
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(locationLists, id: \.self) { locationData in
                    CustomItemView(locationData: locationData, addToggleState: $addToggle, updateCompletion: { updateStr in
                        guard let updateAlias = updateStr else {
                            self.locationViewModel.deleteLocationList(locationData)
                            locationLists = locationViewModel.locationLists
                            locationUpdateHandler?(true)
                            return
                        }
                        self.locationViewModel.updateLocationForAlias(locationData, editAlias: updateAlias)
                        locationLists = locationViewModel.locationLists
                        locationUpdateHandler?(true)
                    })
                }
                
                if let locationData = locationViewModel.addUILocationList() {
                    CustomItemView(locationData: locationData, addToggleState: $addToggle)
                }
            }
            .padding(.horizontal)
        }

        .onAppear {
            locationLists = locationViewModel.locationLists
        }
        .frame(height: 80)
        .sheet(isPresented: $addToggle) {
            CustomAlertView(originalStr: $addLocationName, title: "추가", message: "장소를 추가(예 : 회사, 학교).", LButtonTitle: "취소", RButtonTitle: "추가", onSave: { isResult in
                if !isResult.isEmpty {
                    print("addLocationName : \(isResult)")
                    let locationData: UserPlaceInfoData = UserPlaceInfoData()
                    locationData.alias = isResult
                    locationData.isSelected = false
                    self.locationViewModel.saveLocationList(locationData)
                    locationLists = self.locationViewModel.locationLists
                    locationUpdateHandler?(true)
                }
                addToggle = false
            })
            .clearModalBackground()
        }
    }
    
    func updateLocation(editId: String) async {
        locationViewModel.updateLocationList(editId)
        locationLists = locationViewModel.locationLists
    }
}

