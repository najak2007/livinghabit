//
//  WeatherServiceManager.swift
//  livinghabit
//
//  Created by 오션블루 on 4/30/25.
//

import Foundation
import WeatherKit
import CoreLocation

@MainActor
class WeatherServiceManager: ObservableObject {
    private let weatherService = WeatherService()       // 'shared'가 아닌 인스턴스 생성
    
    @Published var currentWeather: CurrentWeather?
    
    func getWeather(for location: CLLocationCoordinate2D) async {
        do {
            print("location:", location)
            let weather = try await weatherService.weather(for: CLLocation(latitude: location.latitude, longitude: location.longitude))
            self.currentWeather = weather.currentWeather
        } catch {
            print("Failed to fetch weather data:\(error.localizedDescription)")
        }
    }
}

