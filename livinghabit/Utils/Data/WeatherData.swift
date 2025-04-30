//
//  WeatherData.swift
//  livinghabit
//
//  Created by najak on 4/30/25.
//

import UIKit


struct WeatherData: Codable {
    let name: String
    let main: WeatherMain
    let weather: [Weather]
    
    var image: UIImage? {
        return WeatherData.getWeatherImage(id: weather[0].id)
    }
}

struct WeatherMain: Codable {
    let temp: Double            // 온도
    let humidity: Double        // 습도
    
}

struct Weather: Codable {
    let description: String
    let id: Int
}

extension WeatherData {
    static func getWeatherImage(id: Int) -> UIImage? {
        var imageName: String
        switch id {
        case 200...232:
            imageName = "cloud.bolt"
        case 300...321:
            imageName = "cloud.drizzle"
        case 500...531:
            imageName = "cloud.rain"
        case 600...622:
            imageName = "cloud.snow"
        case 701...781:
            imageName = "cloud.fog"
        case 800:
            imageName = "sun.max"
        case 801...804:
            imageName = "cloud.bolt"
        default:
            imageName = "cloud"
        }
        return UIImage(systemName: imageName)
    }
}
