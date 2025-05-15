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
    @StateObject var viewModel = MapViewModel()
    @State var region: MKCoordinateRegion?
    @StateObject var commonViewModel: CommonViewModel
    
    var body: some View {
        VStack {
            WrapperView(view: viewModel.mapView)
                .ignoresSafeArea()
        }
        .overlay {
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Image("talk_close")
            }
            .position(x: 15, y: 15)
        }
        .onAppear {
            viewModel.setCenter(region)
            commonViewModel.isBackButtonHidden = true
        }
        .navigationBarHidden(true)
    }
}

