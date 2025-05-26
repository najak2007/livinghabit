//
//  MapView.swift
//  livinghabit
//
//  Created by 오션블루 on 5/12/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.scenePhase) var scenePhase
    
    @ObservedObject var viewModel = MapViewModel()
    @State var region: MKCoordinateRegion?
    
    var body: some View {
        VStack {
            WrapperView(view: viewModel.mapView)
                .ignoresSafeArea()
        }
        .overlay {
            VStack {
                HStack {
                    Spacer()
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image("talk_close")
                    }
                }
                Spacer()
                
                Text("\(viewModel.userLatitude), \(viewModel.userLongitude)")
            }
            .padding()
        }
        .onAppear {
            viewModel.setCenter(region)
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active, oldPhase == .inactive {
                viewModel.setCenter(region)
            }
        }
        .navigationBarHidden(true)
    }
}

