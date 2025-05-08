//
//  HealthView.swift
//  livinghabit
//
//  Created by 오션블루 on 5/8/25.
//

import SwiftUI
import MapKit

struct HealthView: View {
    //서울 좌표
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.5666791, longitude: 126.9782914), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    var body: some View {
        Map(coordinateRegion: $region)
    }
}
