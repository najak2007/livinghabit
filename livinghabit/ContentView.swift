//
//  ContentView.swift
//  livinghabit
//
//  Created by 오션블루 on 4/10/25.
//

import SwiftUI
import CoreLocation
import MapKit

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject private var timeViewModel = TimeViewModel()
    
    @State private var isShowCalendar: Bool = false
    @State private var date = Date()
    @State private var latitude: Double?
    @State private var longitude: Double?
    @State private var location: CLLocationCoordinate2D?
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.5666791, longitude: 126.9782914), span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009))
    
 //   @StateObject var locationManager = LocationManager()
    @StateObject var weatherServiceManager = WeatherServiceManager()
    @StateObject var commonViewModel: CommonViewModel = .init()
    
    
    @State private var isToDoListFlag: Bool = false
    @State private var isFinishListFlag: Bool = false
    @State private var isEatListFlag: Bool = false
    @State private var isTimerListFlag: Bool = false
    @State private var isHealthListFlag: Bool = false
    @State private var isMapFlag: Bool = false
    
    private var today = Date()

    let manager = NotificationManager.instance
    
    let dateformat: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateFormat = "MM.dd"
        fmt.locale = Locale(identifier: "ko_KR")
        return fmt
    }()
    
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        
                    }, label: {
                        Text(Date().dateCompare(fromDate: date) == "S" ? "오늘" : "")
                            .font(.custom("AppleSDGothicNeo-Bold", size: Date().dateCompare(fromDate: date) == "S" ? 24 : 0 ))
                            .foregroundColor(colorScheme == .dark ? Color(hex: "#FFFFFF") : Color(hex: "#000000"))
                        
                        Text(dateformat.string(from: date))
                            .font(.custom(Date().dateCompare(fromDate: date) == "S" ? "AppleSDGothicNeo-Regular" : "AppleSDGothicNeo-Bold", size: Date().dateCompare(fromDate: date) == "S" ? 15 : 24))
                            .foregroundColor(colorScheme == .dark ?  Color(hex: "#FFFFFF") : Color(hex: "#000000"))
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        date = Date()
                    }, label: {
                        Text(Date().dateCompare(fromDate: date) == "S" ? "" : "오늘")
                            .font(.custom("AppleSDGothicNeo-Medium", size: Date().dateCompare(fromDate: date) == "S" ? 0 : 15 ))
                    })
                }
            }
            .overlay {
                DatePicker(
                    selection: $date,
                    displayedComponents: [.date]
                ) {}
                .labelsHidden()
                .colorMultiply(.clear)
                .datePickerStyle(.compact)
                .environment(\.locale, Locale(identifier: String(Locale.preferredLanguages[0])))
                
            }
            .padding(.horizontal, 20)
        
            List {
                Button(action: {
                    self.isToDoListFlag.toggle()
                }, label: {
                    Text("☑️ 할 일")
                        .font(.custom("AppleSDGothicNeo-Medium", size: 19))
                        .foregroundColor(colorScheme == .dark ?  Color(hex: "#FFFFFF") : Color(hex: "#000000"))
                })
                .fullScreenCover(isPresented: $isToDoListFlag) {
                    ToDoListView()
                }
                
                Button(action: {
                    self.isFinishListFlag.toggle()
                }, label: {
                    Text("✅ 한 일")
                        .font(.custom("AppleSDGothicNeo-Medium", size: 19))
                        .foregroundColor(colorScheme == .dark ?  Color(hex: "#FFFFFF") : Color(hex: "#000000"))
                })
                .fullScreenCover(isPresented: $isFinishListFlag) {
                    FinishingListView()
                }
                
                Button(action: {
                    self.isEatListFlag.toggle()
                }, label: {
                    Text("🥙 식단")
                        .font(.custom("AppleSDGothicNeo-Medium", size: 19))
                        .foregroundColor(colorScheme == .dark ?  Color(hex: "#FFFFFF") : Color(hex: "#000000"))

                })
                
                Button(action: {
                    self.isTimerListFlag.toggle()
                }, label: {
                    Text("⏰ 시간 관리")
                        .font(.custom("AppleSDGothicNeo-Medium", size: 19))
                        .foregroundColor(colorScheme == .dark ?  Color(hex: "#FFFFFF") : Color(hex: "#000000"))
                })
                .fullScreenCover(isPresented: $isTimerListFlag) {
                    TimeListView()
                }
                
                Button(action: {
                    self.isMapFlag.toggle()
                }, label: {
                    Text("🏃‍♂️‍➡️ 걷기 운동")
                        .font(.custom("AppleSDGothicNeo-Medium", size: 19))
                        .onChange(of: scenePhase) { oldPhase, newPhase in
                            print("oldPhase = \(oldPhase), newPhase = \(newPhase)")
                            if newPhase == .active, oldPhase == .inactive {
                                currentRegion()
                            }
                        }
                        .foregroundColor(colorScheme == .dark ?  Color(hex: "#FFFFFF") : Color(hex: "#000000"))
                })
                .fullScreenCover(isPresented: $isMapFlag) {
                    MapView(isHealthMode: true)
                }
            }.environment(\.defaultMinListRowHeight, 70)

        }
        .onAppear {
            manager.requestAuthorization()
        }
        .task() {
//            currentRegion()
        }
    }
    
    private func currentRegion() {
//        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locationManager.location?.latitude ?? 37.5666791, longitude: locationManager.location?.longitude ?? 126.9782914), span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009))
    }
    
//    func startPermissionTask() async {
//        let locationManager = CLLocationManager()
//        let authorizationStatus = locationManager.authorizationStatus
//        
//        // 위치 사용 권한 항상 허용되어 있음
//        if authorizationStatus == .authorizedAlways {
//            
//        } else if authorizationStatus == .authorizedWhenInUse {     // 위치 사용 권한 앱 사용 시 허용되어 있음
//            locationManager.requestAlwaysAuthorization()
//        } else if authorizationStatus == .denied {                  // 위치 사용 권한 거부되어 있음
//            DispatchQueue.main.async {
//                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
//            }
//        } else if authorizationStatus == .notDetermined || authorizationStatus == .restricted {
//            locationManager.requestWhenInUseAuthorization()
//        }
//    }
//    
//    func getCurrentLocation()  {
//        let locationManager = CLLocationManager()
//        locationManager.distanceFilter = 10
////        locationManager.startUpdatingLocation()
//
//        let coordinate = locationManager.location?.coordinate
//        self.latitude = coordinate?.latitude ?? 0
//        self.longitude = coordinate?.longitude ?? 0
//    }
}


