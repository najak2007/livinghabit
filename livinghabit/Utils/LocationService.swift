//
//  LocationService.swift
//  livinghabit
//
//  Created by najak on 4/30/25.
//

import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    var completionHandler: ((CLLocationCoordinate2D) -> Void)?
    
    override init() {
        super.init()
        
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        
        super.setValue(true, forKey: "isAppleSilentRemoteNotificationEnabled")
        super.setValue(true, forKey: "UIBackgroundModes")
        super.setValue(["location"], forKey: "UIBackgroundModes")
    }
    
    func requestLocation(completion: @escaping((CLLocationCoordinate2D) -> (Void))) {
        completionHandler = completion
        manager.requestLocation()
    }
    
    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        if let completion = self.completionHandler {
            completion(location.coordinate)
        }
        self.manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to update location: \(error.localizedDescription)")
    }
}
