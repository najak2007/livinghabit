//
//  DietMenuViewModel.swift
//  livinghabit
//
//  Created by najak on 6/30/25.
//

import Foundation
import RealmSwift

class DietMenuViewModel: ObservableObject {
    private var realm: Realm?
    @Published var mealLists: [DietMenu] = []
    
    init() {
        do {
            realm = try Realm()
            fetchThreeMeals()
        } catch {
            
        }
    }
    
    func saveMealList(_ mealItem: DietMenu) {
        guard let realm = realm else { return }
        
        do {
            try realm.write {
                if mealItem.id.isEmpty {
                    mealItem.id = self.getToDoListDataID()
                }
                realm.add(mealItem)
                fetchThreeMeals()
            }
        } catch {
            
        }
    }
    
    func deleteMealList(at offsets: IndexSet) {
        guard let realm = realm else { return }
        
        do {
            try realm.write {
                let objectsToDelete = offsets.map { self.mealLists[$0] }
                realm.delete(objectsToDelete)
                fetchThreeMeals()
            }
        } catch {
            
        }
    }
    
    func moveList(from source: IndexSet, to destination: Int) {
        self.mealLists.move(fromOffsets: source, toOffset: destination)
        
        self.updateOrderByIndex()
    }
    
    func updateMealList(dietMenu: DietMenu, newFoodStr: String) {
        guard let realm = realm else { return }
        
        try! realm.write {
            dietMenu.food = newFoodStr
        }
        fetchThreeMeals()
    }
    
    func fetchThreeMeals() {
        guard let realm = realm else { return }
        let results = realm.objects(DietMenu.self)
        mealLists = Array(results)
    }
    
    private func updateOrderByIndex() {
        guard let realm = realm else { return }
        
        do {
            try realm.write {
                var orderIndex = 0
                for mealItems in self.mealLists {
                    mealItems.orderByIndex = orderIndex
                    orderIndex += 1
                }
            }
        } catch {
            
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
