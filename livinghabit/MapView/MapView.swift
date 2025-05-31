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
    @Environment(\.colorScheme) var colorScheme
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
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image("talk_close")
                    })
    
                    Spacer()
    
                    Button(action: {
    
                    }, label: {
                        Image(systemName: "mappin.and.ellipse.circle.fill")
                            .resizable()
                            .foregroundColor(colorScheme == .dark ?  Color(hex: "#FFFFFF") : Color(hex: "#000000"))
                            .frame(width: 30, height: 30)
                    })
                }
                .padding(.horizontal, 10)
                .padding(.vertical , 0)
                .background(Color.clear)

                Spacer()
                
                Text("\(viewModel.userLatitude), \(viewModel.userLongitude)")
            }
        }
        .onAppear {
            viewModel.setCenter(nil)
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active, oldPhase == .inactive {
                viewModel.setCenter(nil)
            }
        }
        .navigationBarHidden(true)
    }
}

