//
//  MapViewModel.swift
//  livinghabit
//
//  Created by 오션블루 on 5/12/25.
//

import Foundation
import MapKit
import CoreLocation

class MapViewModel: NSObject, ObservableObject {
    let mapView = MKMapView()
    var region: MKCoordinateRegion?
    
    private let locationManager = CLLocationManager()
    
    @Published var userLatitude: Double = 0
    @Published var userLongitude: Double = 0
    
    @Published var errorMessage: String?
    
    override init() {
        super.init()
        mapView.delegate = self
#if false       /* true : map 의 위치 조정이 안된다. */
        mapView.isUserInteractionEnabled = false
#endif
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        addGestureRecognizer()
    }

    private func addGestureRecognizer() {
        let longTopGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleTap))
        mapView.addGestureRecognizer(longTopGesture)
    }
    
    @objc func handleTap(gestureReconizer: UITapGestureRecognizer) {
        let locationOnMap = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(locationOnMap, toCoordinateFrom: mapView)
        print("On long tap coordinates: \(coordinate)")
    }
    
    func setCenter(_ currentRegion: MKCoordinateRegion? = nil) {
        guard var region = currentRegion else { return }
        region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
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
        print(annotation.title as Any, annotation.coordinate)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotation === mapView.userLocation {
            annotationView?.annotation = annotation
            return annotationView
        }
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        } else {
            annotationView?.annotation = annotation
        }
//        annotationView?.image = UIImage(systemName: "mappin.and.ellipse")?.withTintColor(.red)

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.systemBlue
        renderer.lineWidth = 10
        return renderer
    }
}

extension MapViewModel: CLLocationManagerDelegate {
    func startUpdatingLocation() {
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        userLatitude = location.coordinate.latitude
        userLongitude = location.coordinate.longitude
    }
}
