//
//  HealthView.swift
//  livinghabit
//
//  Created by 오션블루 on 5/8/25.
//

import SwiftUI
import MapKit


struct MapLocation: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct HealthView: View {
    //서울 좌표
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.5666791, longitude: 126.9782914), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            Map(
                coordinateRegion: $region,
                showsUserLocation: true,
//                annotationItems: [MapLocation(name: "", latitude: region.center.latitude, longitude: region.center.longitude)],
//                annotationContent: { location in
//                    MapPin(coordinate: location.coordinate, tint: .red)
//                }
            )
        }
        .overlay {
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Image("talk_close")
            }
            .position(x: 30, y: 30)
        }
        .navigationBarHidden(true)
    }
}
