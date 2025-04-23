//
//  LivingHabitData.swift
//  livinghabit
//
//  Created by 오션블루 on 4/21/25.
//

import Foundation
import RealmSwift

class LocationInfoData: Object {
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    @objc dynamic var address: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var alias: String = ""
}

final class ToDoListData: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var toDoList: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var date: Date = Date()
}

final class LivingHabitData: Object {
    @objc dynamic var id = ""
    @objc dynamic var date = Date()
    @objc dynamic var image: Data? = nil
    @objc dynamic var toDoList: ToDoListData? = nil
    @objc dynamic var memo = ""
    @objc dynamic var placeList: Array<LocationInfoData> = []
    
}
