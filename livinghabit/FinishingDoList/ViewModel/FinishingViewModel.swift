//
//  FinishingViewModel.swift
//  livinghabit
//
//  Created by 오션블루 on 4/29/25.
//

import Foundation
import RealmSwift

class FinishingViewModel: ObservableObject {
    private var realm: Realm?
    @Published var toDoLists: [ToDoListData] = []
    
    init() {
        realm = try? Realm()
        fetchToDoLists()
    }
    
    private func fetchToDoLists() {
        guard let realm = realm else { return }

    }
}
