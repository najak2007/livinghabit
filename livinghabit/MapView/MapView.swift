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
    var isSearchTextField: Bool = false
    
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
                    
                    if isSearchTextField == false {
                        Spacer()
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "mappin.and.ellipse.circle.fill")
                                .resizable()
                                .foregroundColor(colorScheme == .dark ?  Color(hex: "#FFFFFF") : Color(hex: "#000000"))
                                .frame(width: 30, height: 30)
                        })
                    } else {
                        SearchBar(text: $searchText, searchHandler: {
                            if searchText.isEmpty == false {
                                Task {
                                    let coordinate = try await viewModel.getCoordinateFromRoadAddress(from: searchText)
                                    viewModel.searchToLocation(coordinate: coordinate)
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
            viewModel.setCenter(nil)
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

