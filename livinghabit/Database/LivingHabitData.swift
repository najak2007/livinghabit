//
//  LivingHabitData.swift
//  livinghabit
//
//  Created by 오션블루 on 4/21/25.
//

import Foundation
import RealmSwift

class UserPlaceInfoData: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    @objc dynamic var address: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var alias: String = ""
    @objc dynamic var isAddLocation: Bool = false
    @objc dynamic var isSelected: Bool = false
}

class LocationInfoData: Object {
    @objc dynamic var id: String = ""
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

final class HourWeatherData: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var temperature: String = ""
    @objc dynamic var dewPoint: String = ""
    @objc dynamic var humidity: String = ""
    @objc dynamic var windSpeed: String = ""
    @objc dynamic var condition: String = ""
    @objc dynamic var isDaylight: Bool = false
    @objc dynamic var unIndex: Int = 0
    @objc dynamic var date: Date = Date()
}

final class DayWeatherData: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var symbolName: String = ""
    @objc dynamic var highTemperature: String = ""
    @objc dynamic var lowTemperature: String = ""
    @objc dynamic var sun: String = ""
    @objc dynamic var moon: String = ""
    @objc dynamic var uvIndex: String = ""
    @objc dynamic var date: Date = Date()
}

final class WeatherData: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    @objc dynamic var temperature: String = ""
    @objc dynamic var dewPoint: String = ""
    @objc dynamic var humidity: String = ""
    @objc dynamic var windSpeed: String = ""
    @objc dynamic var condition: String = ""
    @objc dynamic var isDaylight: Bool = false
    @objc dynamic var unIndex: Int = 0
    @objc dynamic var date: Date = Date()
    dynamic var hourWeatherDataList: List<HourWeatherData> = List<HourWeatherData>()
    dynamic var dayWeatherDataList: List<DayWeatherData> = List<DayWeatherData>()
}

final class LivingHabitData: Object {
    @objc dynamic var id = ""
    @objc dynamic var date = Date()
    @objc dynamic var image: Data? = nil
    @objc dynamic var toDoList: ToDoListData? = nil
    @objc dynamic var memo = ""
    @objc dynamic var placeList: LocationInfoData? = nil
}
