//
//  LocationManager.swift
//  livinghabit
//
//  Created by 오션블루 on 4/30/25.
//

import Foundation
import CoreLocation
import UIKit
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var errorMessage: String?
        
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude

            if let previousCoordinate = self.location {
                var points: [CLLocationCoordinate2D] = []
                let point1 = CLLocationCoordinate2DMake(previousCoordinate.latitude, previousCoordinate.longitude)
                let point2: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                
                points.append(point1)
                points.append(point2)
                
                let lineDraw = MKPolyline(coordinates: points, count: points.count)
            }
            self.location = location.coordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = "Failed to get user location : \(error.localizedDescription)"
    }
}

extension LocationManager: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyLine = overlay as? MKPolyline else {
            print("Can't draw polyline")
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyLine)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3.0
        renderer.alpha = 0.7
        
        return renderer
    }
}
