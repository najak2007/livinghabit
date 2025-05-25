//
//  MapViewModel.swift
//  livinghabit
//
//  Created by 오션블루 on 5/12/25.
//

import Foundation
import MapKit
import CoreLocation
import RealmSwift

class MapViewModel: NSObject, ObservableObject {
    let mapView = MKMapView()
    var region: MKCoordinateRegion?
    
    private let locationManager = CLLocationManager()
    private var realm: Realm?
    
    @Published var userLatitude: Double = 0
    @Published var userLongitude: Double = 0
    
    @Published var errorMessage: String?
    @Published var locationInfoDatas: [LocationInfoData] = []
    
    override init() {
        super.init()
        mapView.delegate = self
#if false       /* true : map 의 위치 조정이 안된다. */
        mapView.isUserInteractionEnabled = false
#endif
        locationManager.requestWhenInUseAuthorization()

        locationManager.allowsBackgroundLocationUpdates = true          // 백그라운드 업데이트 활성화
        locationManager.pausesLocationUpdatesAutomatically = false
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        addGestureRecognizer()
        
        do {
            realm = try Realm()
            fetchToLocations()
        } catch {
            print("Error initializing Realm: \(error)")
        }
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
        var region = currentRegion
        if region == nil {
            region = self.currentRegion()
        }
        
        region!.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        mapView.setRegion(region!, animated: true)
        mapView.showsUserLocation = true
        addAnnotation(currentRegion)
    }
    
    func addAnnotation(_ currentRegion: MKCoordinateRegion?) {
        guard let region = currentRegion else { return }
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: region.center.latitude, longitude: region.center.longitude)
        mapView.addAnnotation(annotation)
    }
    
    func fetchToLocations() {
        guard let realm = realm else { return }
        let results = realm.objects(LocationInfoData.self)
        locationInfoDatas = Array((results))
    }
    
    func saveToLocation(_ location: LocationInfoData) {
        guard let realm = realm else { return }
        
        do {
            try realm.write {
                realm.add(location)
                fetchToLocations()
            }
        } catch {
            print("Error saving Location: \(error)")
        }
    }
    
    private func currentRegion() -> MKCoordinateRegion {
        return MKCoordinateRegion(center: CLLocationCoordinate2D(
            latitude: locationManager.location?.coordinate.latitude ?? 37.5666791,
            longitude: locationManager.location?.coordinate.longitude ?? 126.9782914), span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009))
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
        
        let locationData = LocationInfoData()
        locationData.id = getToLocationID()
        locationData.latitude = userLatitude
        locationData.longitude = userLongitude
        locationData.date = Date()
        
        self.saveToLocation(locationData)
        
    }
    
    func getToLocationID() -> String {
        let date: Date = Date()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let nowID: String = dateFormatter.string(from: date)
        return nowID
    }
}
