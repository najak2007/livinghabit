//
//  WeatherViewModel.swift
//  livinghabit
//
//  Created by najak on 5/7/25.
//

import Foundation
import RealmSwift

class WeatherViewModel: ObservableObject {
    private var realm: Realm?
    @Published var weather: WeatherData?
    
    init() {
        do {
            realm = try Realm()
            
        } catch {
            
        }
    }
    
    func saveWeatherData(_ weatherDate: WeatherData) {
        guard let realm = realm else { return }
        
        do {
            try realm.write {
                realm.add(weatherDate)
            }
        } catch {
            
        }
    }
    
    func deleteAllWeatherData() {
        guard let realm = realm else { return }
        
        do {
            try realm.write {
                
            }
        } catch {
            
        }
    }
}
