//
//  ToDoListViewModel.swift
//  livinghabit
//
//  Created by 오션블루 on 4/22/25.
//

import Foundation
import RealmSwift

class ToDoListViewModel: ObservableObject {
    private var realm: Realm?
    @Published var toDoLists: [ToDoListData] = []
    
    init() {
        do {
            realm = try Realm()
            fetchToDoLists()
        } catch {
            print("Error initializing Realm: \(error)")
        }
    }
    
    func saveToDoList(_ toDoList: ToDoListData) {
        guard let realm = realm else { return }
        
        do {
            try realm.write {
                realm.add(toDoList)
                fetchToDoLists()
            }
        } catch {
            print("Error saving ToDoList: \(error)")
        }
    }
    
    func deleteToDoList(at offsets: IndexSet) {
        guard let realm = realm else { return }
        
        do {
            try realm.write {
                let objectsToDelete = offsets.map { self.toDoLists[$0] }
                realm.delete(objectsToDelete)
                fetchToDoLists()
            }
        } catch {
            print("Error deleting ToDoList :\(error)")
        }
    }
    
    func updateToDoList(toDoListData: ToDoListData, newToDoList: String) {
        guard let realm = realm else { return }
        
        try! realm.write {
            toDoListData.toDoList = newToDoList
            toDoListData.date = Date()
        }
        fetchToDoLists()
    }
    
    func fetchToDoLists() {
        guard let realm = realm else { return }
        let results = realm.objects(ToDoListData.self)
        toDoLists = Array(results)
    }
}
