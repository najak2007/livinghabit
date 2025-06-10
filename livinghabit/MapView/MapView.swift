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
    @State private var searchText = ""
    @State private var placemarkMenu: [CLPlacemark] = []
    
    var searchLocationPlace: UserPlaceInfoData? = nil
    
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
                    
                    if searchLocationPlace == nil {
                        Spacer()
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "mappin.and.ellipse.circle.fill")
                                .resizable()
                                .foregroundColor(colorScheme == .dark ?  Color(hex: "#FFFFFF") : Color(hex: "#000000"))
                                .frame(width: 30, height: 30)
                        })
                    } else {
                        SearchBar(text: $searchText, placemarkMenu: $placemarkMenu, searchHandler: {
                            if searchText.isEmpty == false {
                                Task {
                                    let placemarks: [CLPlacemark] = try await viewModel.getCoordinateFromRoadAddress(from: searchText)
                                    if placemarks.isEmpty == false {
                                        let coordinate = placemarks.first?.location?.coordinate ?? CLLocationCoordinate2D()
                                        viewModel.searchToLocation(coordinate: coordinate)
                                        placemarkMenu = placemarks
                                    }
                                }
                            }
                        })
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical , 0)
                .background(Color.clear)

                Spacer()
                
                Text("\(viewModel.userLatitude), \(viewModel.userLongitude)")
            }
        }
        .onAppear {
            if searchLocationPlace == nil {
                viewModel.setCenter(nil)
                viewModel.searchLocationPlace = nil
            } else {
                viewModel.setCenter(nil, isSearchMode: searchLocationPlace == nil ? false : true, selectedLocationHandler: { placeInfoData in
                    
                })
                viewModel.searchLocationPlace = searchLocationPlace
            }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active, oldPhase == .inactive {
                viewModel.setCenter(nil)
            }
        }
        .navigationBarHidden(true)
        .background(Color.white)
    }
}

