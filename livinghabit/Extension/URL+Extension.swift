//
//  URL+Extension.swift
//  livinghabit
//
//  Created by najak on 4/30/25.
//

import Foundation
import CoreLocation

let appid = "JQ7R73UL66"
let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(appid)&units=metric"

extension URL {
    static func urlWith(city: String) -> URL? {
        return URL(string: "\(weatherURL)&q=\(city)")
    }
    
    static func urlWith(coordinate: CLLocationCoordinate2D) -> URL? {
        return URL(string: "\(weatherURL)&lat=\(coordinate.latitude)&lon=\(coordinate.longitude)")
    }
}
