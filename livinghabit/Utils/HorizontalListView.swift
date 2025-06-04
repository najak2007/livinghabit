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
//    @Binding var editId: String
    var updateCompletion: ((UserPlaceInfoData) -> Void)? = nil
    
    
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
                        
                    }, label: {
                        Text("📍 위치")
                          .padding()
                          .font(.custom("AppleSDGothicNeo-Medium", size: 20))
                          .foregroundColor(colorScheme == .dark ? Color(hex: "#FFFFFF") : Color(hex: "#000000"))
                    })


                    Button(action: {
                        
                    }, label: {
                        Text("📝 수정")
                          .padding()
                          .font(.custom("AppleSDGothicNeo-Medium", size: 20))
                          .foregroundColor(colorScheme == .dark ? Color(hex: "#FFFFFF") : Color(hex: "#000000"))
                    })
                    
                    Button(action: {
                        
                    }, label: {
                        Text("⛔️ 삭제")
                          .padding()
                          .font(.custom("AppleSDGothicNeo-Medium", size: 20))
                          .foregroundColor(colorScheme == .dark ? Color(hex: "#FFFFFF") : Color(hex: "#000000"))
                    })
                } label: {
                    Text(locationData.alias)
                        .padding()
                        .font(.custom("AppleSDGothicNeo-Medium", size: 20))
                        .foregroundColor(colorScheme == .dark ? Color(hex: "#FFFFFF") : Color(hex: "#000000"))
                        .frame(minWidth: 70, maxHeight: 40)
                }

            }
        }
        .background(Color.gray.opacity(0.3))
        .cornerRadius(10)
        .padding(2)
    }
}

struct HorizontalListView: View {
    @Binding var locationViewModel: LocationViewModel
    @Binding var isLocationDataUpdate: Bool
    
    @State private var locationLists: [UserPlaceInfoData] = []
    
    @State private var addToggle: Bool = false
    @State private var addLocationName: String = ""
    @State private var newLocationName: String = ""
    @State private var editId: String = ""

    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(locationLists, id: \.self) { locationData in
                    CustomItemView(locationData: locationData, addToggleState: $addToggle, updateCompletion: { userPlaceInfoData in
                        
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
                    isLocationDataUpdate = true
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

