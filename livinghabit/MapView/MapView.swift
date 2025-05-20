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
    @ObservedObject var viewModel = MapViewModel()
    @State var region: MKCoordinateRegion?
    @StateObject var commonViewModel: CommonViewModel
//    @ObservedObject var vm = MapViewModel()
    
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
                    .onAppear {
                        viewModel.startUpdatingLocation()
                    }
            }
            .padding()
        }
        .onAppear {
            viewModel.setCenter(region)
            commonViewModel.isBackButtonHidden = true
        }
        .navigationBarHidden(true)
    }
}

