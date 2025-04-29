//
//  ContentView.swift
//  livinghabit
//
//  Created by 오션블루 on 4/10/25.
//

import SwiftUI


struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isShowCalendar: Bool = false
    @State private var date = Date()
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
                        date = Date()
                    }, label: {
                        Text(Date().dateCompare(fromDate: date) == "S" ? "" : "오늘")
                            .font(.custom("AppleSDGothicNeo-Medium", size: Date().dateCompare(fromDate: date) == "S" ? 0 : 15 ))
                    })
                    
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

                    NavigationLink(destination: Text("Detail View 3")) {
                        Text("🏃‍♂️‍➡️ 운동")
                            .font(.custom("AppleSDGothicNeo-Medium", size: 19))
                    }

                }.environment(\.defaultMinListRowHeight, 70)
            }
        }
    }
    
}

#Preview {
    ContentView()
}
