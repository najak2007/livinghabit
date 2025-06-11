//
//  MapView.swift
//  livinghabit
//
//  Created by 오션블루 on 5/12/25.
//

import SwiftUI
import MapKit
import ActivityKit

struct MapView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.scenePhase) var scenePhase
    
    @ObservedObject var viewModel = MapViewModel()
    @State var region: MKCoordinateRegion?
    @State private var searchText = ""
    @State private var placemarkMenu: [CLPlacemark] = []
    @State private var showUserPlaceSave: Bool = false
    @State private var isObjectiveShow: Bool = false
    
    var searchLocationPlace: UserPlaceInfoData? = nil
    var isHealthMode: Bool = false
    @State private var selectingCoordinate: CLLocationCoordinate2D? = nil
    var updateLocationDataCompletion: ((UserPlaceInfoData, CLLocationCoordinate2D) -> Void)? = nil
    
    var body: some View {
        ZStack {
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
                    if isHealthMode {
                        VStack {
                            CircleButton(title: "시작", action: {
                                startLiveActivity()
                            })
                            .padding()
                            .shadow(color: .gray, radius: 5, x: 0, y: 5)

                            RoundedButton(title: "목표 설정", action: {
                                isObjectiveShow.toggle()
                            })
                        }
                    }
                }
            }

            ZStack(alignment: .bottom) {
                Color.black.opacity(0.1)
                    .opacity(isObjectiveShow ? 1 : 0)
                    .onTapGesture {
                        isObjectiveShow = false
                    }

                if self.isObjectiveShow {
                    BottomSheetView($isObjectiveShow, height: 300) {
                        VStack {
                            HealthObjectiveView { objectiveItem in

                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .animation(.interactiveSpring(), value: isObjectiveShow)
        }
        .onAppear {
            if searchLocationPlace == nil {
                viewModel.setCenter(nil)
                viewModel.searchLocationPlace = nil
            } else {
                viewModel.setCenter(nil, isSearchMode: searchLocationPlace == nil ? false : true, selectedLocationHandler: { originalUserPlaceInfo, selectedCoordinate in
                    selectingCoordinate = selectedCoordinate
                    self.showUserPlaceSave.toggle()
                })
                viewModel.searchLocationPlace = searchLocationPlace
            }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active, oldPhase == .inactive {
                viewModel.setCenter(nil)
            }
        }
        .sheet(isPresented: $showUserPlaceSave) {
            ConfirmAlertView(title: searchLocationPlace?.alias ?? "", message: "위치를 저장할까요?", LButtonTitle: "아니오", RButtonTitle: "예", onSave: {
                isResult in
                if isResult == true {
                    guard let updateHandler = updateLocationDataCompletion else { return }
                    guard let selectingCoordinate = selectingCoordinate else { return }
                    guard let selectedLocationPlace = searchLocationPlace else { return }

                    updateHandler(selectedLocationPlace, selectingCoordinate)

                    self.presentationMode.wrappedValue.dismiss()
                }
                showUserPlaceSave.toggle()
            })
            .clearModalBackground()
        }
        .navigationBarHidden(true)
    }
    
    private func startLiveActivity() {
        if #available(iOS 16.2, *) {
            if ActivityAuthorizationInfo().areActivitiesEnabled {
                let future = Calendar.current.date(byAdding: .second, value: 1, to: Date())!
                let date = Date.now...future
                let initialContentState = LivingWidgetAttributes.ContentState(taskName: "오늘", timer: date)
                let activityAttributes = LivingWidgetAttributes(isTimer: true)
                let activityContent = ActivityContent(state: initialContentState, staleDate: Calendar.current.date(byAdding: .minute, value: 30, to: Date())!)

                
                do {
                    let activity = try Activity.request(attributes: activityAttributes, content: activityContent)
                    print("Requested Lockscreen Live Activity(Timer) \(String(describing: activity.id)).")
                } catch (let error) {
                    print("Error requesting Lockscreen Live Activity(Timer) \(error.localizedDescription).")
                }
            }
        }
    }
    
    private func endLiveActivity() async {
        if #available(iOS 16.2, *) {
            let finalStatus = LivingWidgetAttributes.titiStatus(taskName: "오늘", timer: Date.now...Date.now)
            let finalContent = ActivityContent(state: finalStatus, staleDate: nil)

            for activity in Activity<LivingWidgetAttributes>.activities {
                await activity.end(finalContent, dismissalPolicy: .immediate)
                print("Ending the Live Activity(Timer): \(activity.id)")
            }
        }
    }
}

