//
//  OBCustomAnnotation.swift
//  livinghabit
//
//  Created by najak on 6/10/25.
//

import Foundation
import MapKit
import RealmSwift

class OBCustomAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D

    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        super.init()
    }
}
