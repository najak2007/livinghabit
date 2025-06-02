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
    var isSelected: Bool = false
    
    @Binding var addToggleState: Bool
    @Binding var selectedId: String
    
    var body: some View {
        VStack {
            Button(action: {
                if locationData.isAddLocation == true {
                    addToggleState.toggle()
                    return
                }
                if locationData.isSelected == false {
                    selectedId = locationData.id
                }
            }, label: {
                Text(locationData.alias)
                    .padding()
                    .font(.custom("AppleSDGothicNeo-Bold", size: 20))
                    .foregroundColor(colorScheme == .dark ? Color(hex: "#FFFFFF") : Color(hex: "#000000"))
                    .frame(minWidth: 65, maxHeight: 40)
            })
        }
        .overlay {
            if locationData.isAddLocation == false  {
                Text(isSelected == true ? "✅" : "☑️")
                    .font(.custom("AppleSDGothicNeo-Regular", size: 13))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.top, 4)
                    .padding(.leading, 4)
            }
        }
        .background(Color.gray.opacity(0.3))
        .cornerRadius(10)
        .padding(2)
    }
}

struct HorizontalListView: View {
    private var locationViewModel = LocationViewModel()

    @State private var locationLists: [UserPlaceInfoData] = []
    
    @State private var addToggle: Bool = false
    @State private var selectedId: String = ""
    @State private var addLocationName: String = ""
    @State private var newLocationName: String = ""
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(locationLists, id: \.self) { locationData in
                    CustomItemView(locationData: locationData, isSelected: locationData.isSelected, addToggleState: $addToggle, selectedId: $selectedId)
                }
                
                if let locationData = locationViewModel.addUILocationList() {
                    CustomItemView(locationData: locationData, addToggleState: $addToggle, selectedId: $selectedId)
                }
            }
            .padding(.horizontal)
        }
        .task(id: selectedId) {
            if selectedId.isEmpty { return }
            await selecteUpdateLocation(selectedId: selectedId)
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
                }
                addToggle = false
            })
            .clearModalBackground()
        }
    }
    
    func selecteUpdateLocation(selectedId: String) async {
        locationViewModel.selectUpdateLocationList(selectedId)
        locationLists = locationViewModel.locationLists
    }
}

