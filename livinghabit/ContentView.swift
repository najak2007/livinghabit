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
    
    @StateObject var locationManager = LocationManager()
    @StateObject var weatherServiceManager = WeatherServiceManager()
    @StateObject var commonViewModel: CommonViewModel = .init()
    
    private var today = Date()

    
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
                    Button(action: {
                        //date = Date()
                    }, label: {
                        Image(colorScheme == .dark ? "btn_back_w_prs" : "btn_back_b_prs")
                            .opacity(commonViewModel.isBackButtonHidden ? 0 : 1)
                    })
                    .padding(.leading, -20)
                    
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
            
            NavigationView {
                List {
                    NavigationLink(destination: ToDoListView()) {
                        Text("☑️ 할 일")
                            .font(.custom("AppleSDGothicNeo-Medium", size: 19))
                    }
                    
                    NavigationLink(destination: Text("Detail View 2")) {
                        Text("✅ 한 일")
                            .font(.custom("AppleSDGothicNeo-Medium", size: 19))
                    }
                    
                    NavigationLink(destination: Text("Detail View 3")) {
                        Text("🥙 식단")
                            .font(.custom("AppleSDGothicNeo-Medium", size: 19))
                    }

                    NavigationLink(destination: HealthView(region: region)) {
                        Text("🏃‍♂️‍➡️ 운동")
                            .font(.custom("AppleSDGothicNeo-Medium", size: 19))
                            .onChange(of: scenePhase) { oldPhase, newPhase in
                                print("oldPhase = \(oldPhase), newPhase = \(newPhase)")
                                if newPhase == .active, oldPhase == .inactive {
                                    currentRegion()
                                }
                            }
                    }
                    
                    NavigationLink(destination: MapView(region: region, commonViewModel: commonViewModel)) {
                        Text("🗺️ 지도")
                            .font(.custom("AppleSDGothicNeo-Medium", size: 19))
                            .onChange(of: scenePhase) { oldPhase, newPhase in
                                print("oldPhase = \(oldPhase), newPhase = \(newPhase)")
                                if newPhase == .active, oldPhase == .inactive {
                                    currentRegion()
                                }
                            }
                    }
#if false
                    NavigationLink(destination: TranslateEXView()) {
                        Text("번역 예정")
                            .font(.custom("AppleSDGothicNeo-Medium", size: 19))
                    }

                    NavigationLink(destination: WeatherView()) {
                        Text("\(timeViewModel.getTimeCondition())")
                    }
                    NavigationLink(destination: Text("날씨 정보")) {
                        if locationManager.location != nil {
                            if let currentWeather = weatherServiceManager.currentWeather {
                                HStack {
                                    Image(systemName: currentWeather.symbolName)
                                        .renderingMode(.original)
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .onChange(of: scenePhase) { oldPhase, newPhase in
                                            print("oldPhase = \(oldPhase), newPhase = \(newPhase)")
                                            if newPhase == .active, oldPhase == .inactive {
                                                Task {
                                                    await weatherServiceManager.getWeather(for: locationManager.location!)
                                                }
                                            }
                                        }
                                    
                                    let unitStr: String = currentWeather.temperature.unit == .fahrenheit ? "°F" : "°C"
                                    Text(String(Int(currentWeather.temperature.value.rounded(.down))) + unitStr)
                                    
                                    Text(currentWeather.condition.description)
                                }
                            } else {
                                ProgressView("")
                                    .onAppear {
                                        Task {
                                            await weatherServiceManager.getWeather(for: locationManager.location!)
                                        }
                                    }
                            }
                        } else if let error = locationManager.errorMessage {
                            Text(error)
                        } else {
                            ProgressView("")
                        }
                    }
#endif
                }.environment(\.defaultMinListRowHeight, 70)
            }
        }
        .task() {
            currentRegion()
        }
    }
    
    private func currentRegion() {
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locationManager.location?.latitude ?? 37.5666791, longitude: locationManager.location?.longitude ?? 126.9782914), span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009))
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


