//
//  LocationViewModel.swift
//  livinghabit
//
//  Created by najak on 5/31/25.
//

import Foundation
import RealmSwift

class LocationViewModel: ObservableObject {
    private var realm: Realm?
    @Published var locationLists: [UserPlaceInfoData] = []
    
    init() {
        do {
            realm = try Realm()
            fetchLocationLists()
        } catch {
            
        }
    }
    
    func saveLocationList(_ locationList: UserPlaceInfoData) {
        guard let realm = realm else { return }

        do {
            try realm.write {
                let savedLocationData = locationList
                if savedLocationData.id.isEmpty {
                    savedLocationData.id = getToDoListDataID()
                }
                
                realm.add(locationList)
                fetchLocationLists()
            }
        } catch {
            print("Error saving saveLocationList: \(error)")
        }
    }
    
    func addUILocationList() -> UserPlaceInfoData? {
        if locationLists.count < 20 {
            let filterAddOptions = locationLists.filter { $0.isAddLocation == true}
            if filterAddOptions.isEmpty {
                let locationList: UserPlaceInfoData = UserPlaceInfoData()
                locationList.id = getToDoListDataID()
                locationList.alias = "➕"
                locationList.isAddLocation = true
                locationList.isSelected = false
                return locationList
            }
        }
        return nil
    }
    
    func deleteLocationList(_ locationList: UserPlaceInfoData) {
        guard let realm = realm else { return }
        try! realm.write {
            realm.delete(locationList)
        }
        fetchLocationLists()
    }
    
    func updateLocationList(_ itemId: String) {
        guard let realm = realm else { return }
        
        do {
            try realm.write {
                locationLists.forEach { (item) in
                    if item.id == itemId {
                        item.isSelected = true
                    } else {
                        item.isSelected = false
                    }
                }
                fetchLocationLists()
            }
        } catch {
            
        }
    }
    
    func updateLocationForAlias(_ userPlaceInfoData: UserPlaceInfoData, editAlias: String) {
        guard let realm = realm else { return }
        do {
            try realm.write {
                userPlaceInfoData.alias = editAlias
            }
            fetchLocationLists()
        } catch {
            
        }
    }
    
    func fetchLocationLists() {
        guard let realm = realm else { return }
        let results = realm.objects(UserPlaceInfoData.self)
        locationLists = Array(results)
        
        if locationLists.isEmpty {
            let locationList: UserPlaceInfoData = UserPlaceInfoData()
            locationList.alias = "집"
            locationList.isSelected = true
            saveLocationList(locationList)
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
