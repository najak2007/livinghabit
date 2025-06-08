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
                if toDoList.id.isEmpty {
                    toDoList.id = self.getToDoListDataID()
                    toDoList.orderByIndex = 99
                }
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
    
    func moveList(from source: IndexSet, to destination: Int) {
        self.toDoLists.move(fromOffsets: source, toOffset: destination)

        self.updateOrderByIndex()
    }
    
    func updateToDoList(toDoListData: ToDoListData, newToDoList: String) {
        guard let realm = realm else { return }
        
        try! realm.write {
            toDoListData.toDoList = newToDoList
        }
        fetchToDoLists()
    }
    
    func updateToDoListStatus(toDoListData: ToDoListData, isDone: Bool) {
        guard let realm = realm else { return }
        
        try! realm.write {
            toDoListData.isDone = isDone
        }
        fetchToDoLists()
    }
    
    private func updateOrderByIndex() {
        guard let realm = realm else { return }
        
        do {
            try realm.write {
                var orderIndex = 0
                for toDoListData in self.toDoLists {
                    toDoListData.orderByIndex = orderIndex
                    orderIndex += 1
                }
            }
        } catch {
            
        }
    }
    
    func fetchToDoLists() {
        guard let realm = realm else { return }
        let results = realm.objects(ToDoListData.self)
        toDoLists = Array(results).sorted { $0.orderByIndex < $1.orderByIndex }
    }
    
    func getToDoListDataID() -> String {
        let date: Date = Date()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let nowID: String = dateFormatter.string(from: date)
        return nowID
    }
}
