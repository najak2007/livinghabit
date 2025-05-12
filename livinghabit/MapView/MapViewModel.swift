//
//  MapViewModel.swift
//  livinghabit
//
//  Created by 오션블루 on 5/12/25.
//

import Foundation
import MapKit

class MapViewModel: NSObject, ObservableObject {
    let mapView = MKMapView()
    
    override init() {
        super.init()
        
        mapView.delegate = self
        setCenter()
        addAnnotation()
    }
    
    func setCenter() {
        var region = MKCoordinateRegion()
        region.center = CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)
        region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        mapView.setRegion(region, animated: true)
    }
    
    func addAnnotation() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)
        annotation.title = "서울"
        mapView.addAnnotation(annotation)
    }
}

extension MapViewModel: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        print(annotation.title, annotation.coordinate)
    }
}
