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
    var region: MKCoordinateRegion?
    
    override init() {
        super.init()
        mapView.delegate = self
//        mapView.isUserInteractionEnabled = false
    }
    
    func setCenter(_ currentRegion: MKCoordinateRegion? = nil) {
        guard var region = currentRegion else { return }
        region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        mapView.setRegion(region, animated: true)
        addAnnotation(currentRegion)
    }
    
    func addAnnotation(_ currentRegion: MKCoordinateRegion?) {
        guard let region = currentRegion else { return }
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: region.center.latitude, longitude: region.center.longitude)
        mapView.addAnnotation(annotation)
    }
}

extension MapViewModel: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        print(annotation.title, annotation.coordinate)
    }
}
