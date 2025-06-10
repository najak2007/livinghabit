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
import SwiftUI

class MapViewModel: NSObject, ObservableObject {
    let mapView = MKMapView()
    var region: MKCoordinateRegion?
    
    private let locationManager = CLLocationManager()
    private var realm: Realm?
    
    @Published var userLatitude: Double = 0
    @Published var userLongitude: Double = 0
    
    @Published var errorMessage: String?
    @Published var locationInfoDatas: [LocationInfoData] = []
    
    var searchForLocationName: String = ""
    
    let manager = NotificationManager.instance
    
    override init() {
        super.init()
        mapView.delegate = self
#if false       /* true : map 의 위치 조정이 안된다. */
        mapView.isUserInteractionEnabled = false
#endif
        mapView.showsCompass = true         // 나침반 표시 여부
        mapView.showsScale = true           // 축척 정보 표시 여부
        
        // 사용자의 위치를 추적합니다
        // follow : 현재 위치를 보여줍니다.
        // followWithHeading : 핸드폰 방향에 따라 지도를 회전시켜 보여줍니다. (앞에 레이더 포함)
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.setUserTrackingMode(.followWithHeading, animated: true)
        
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
    
    func setCenter(_ currentRegion: MKCoordinateRegion? = nil, isSearchMode: Bool = false) {
        var region = currentRegion
        if region == nil {
            region = self.currentRegion()
        }
        
        region!.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        mapView.setRegion(region!, animated: true)
        
        if isSearchMode == false {
            mapView.showsUserLocation = true
        } else {
            addAnnotation(region)
        }
    }
    
    func addAnnotation(_ currentRegion: MKCoordinateRegion?) {
        guard let region = currentRegion else { return }
        let annotation = MKPointAnnotation()
        annotation.title = searchForLocationName
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
    
    func searchToLocation(coordinate: CLLocationCoordinate2D) {
        let region: MKCoordinateRegion = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        mapView.setRegion(region, animated: true)
        
        self.setPinUsingMKPointAnnotation(location: coordinate)
    }

    private func setPinUsingMKPointAnnotation(location: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
    }
    
    private func currentRegion() -> MKCoordinateRegion {
        
        userLatitude = locationManager.location?.coordinate.latitude ?? 37.5666791
        userLongitude = locationManager.location?.coordinate.longitude ?? 126.9782914
        
        return MKCoordinateRegion(center: CLLocationCoordinate2D(
            latitude: locationManager.location?.coordinate.latitude ?? 37.5666791,
            longitude: locationManager.location?.coordinate.longitude ?? 126.9782914), span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009))
    }
    
    private func showAnnotationDetail(annotation: MKAnnotation) {
        if let annotation = annotation as? OBCustomAnnotation {
            
        }
    }
    
}

extension MapViewModel: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        let customAnnotation: OBCustomAnnotation = OBCustomAnnotation(title: searchForLocationName, subtitle: nil, coordinate: annotation.coordinate)
        showAnnotationDetail(annotation: customAnnotation)
    }
    
    
#if false
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
        annotationView?.image = UIImage(systemName: "mappin.and.ellipse")?.withTintColor(.red)

        return annotationView
    }
#endif
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.systemBlue
        renderer.lineWidth = 10
        return renderer
    }
    
    func getCoordinateFromRoadAddress(from address: String) async throws -> [CLPlacemark] {
        let geocoder = CLGeocoder()
        let placemark: [CLPlacemark] = try await geocoder.geocodeAddressString(address)
        return placemark
    }
}

extension MapViewModel: CLLocationManagerDelegate {
    func startUpdatingLocation() {
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        let oldLocation = CLLocation(latitude: userLatitude, longitude: userLongitude)
        let newLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let distance = oldLocation.distance(from: newLocation)
        
        if distance > 10 {
            userLatitude = location.coordinate.latitude
            userLongitude = location.coordinate.longitude
            let locationData = LocationInfoData()
            locationData.id = getToLocationID()
            locationData.latitude = userLatitude
            locationData.longitude = userLongitude
            locationData.date = Date()
            self.saveToLocation(locationData)
        }
        
        let homeLocation = CLLocation(latitude: 37.669440, longitude: 126.889480)
        
        let homeDistance = oldLocation.distance(from: homeLocation)
        
        let isHome = UserDefaults.standard.bool(forKey: "isHome")
        
        if isHome == false {
            if homeDistance > 10, homeDistance < 50 {
                self.manager.scheduleNotification(trigger: .time)
                
                UserDefaults.standard.set(true, forKey: "isHome")
            }
        } else {
            if homeDistance > 80, homeDistance < 100 {
                UserDefaults.standard.set(false, forKey: "isHome")
            }
        }
        
    }
    
    func getToLocationID() -> String {
        let date: Date = Date()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let nowID: String = dateFormatter.string(from: date)
        return nowID
    }
}
