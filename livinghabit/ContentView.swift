//
//  ContentView.swift
//  livinghabit
//
//  Created by 오션블루 on 4/10/25.
//

import SwiftUI


struct ContentView: View {
    private var today = Date()

    
    let dateformat: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateFormat = "MM.dd"
        fmt.locale = Locale(identifier: "ko_KR")
        return fmt
    }()
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ToDoListView()) {
                    Text("☑️ 해야 할일")
                        .font(.custom("AppleSDGothicNeo-Medium", size: 19))
                }
                
                NavigationLink(destination: Text("Detail View 2")) {
                    Text("✅ 끝낸 일")
                        .font(.custom("AppleSDGothicNeo-Medium", size: 19))
                }
                
                NavigationLink(destination: Text("Detail View 3")) {
                    Text("오늘")
                        .font(.custom("AppleSDGothicNeo-Medium", size: 19))
                }
            }.environment(\.defaultMinListRowHeight, 70)
 //           .navigationTitle("오늘 📆\(dateformat.string(from: today))")
            .navigationTitle(
                Text("오늘")
                    .font(.custom("AppleSDGothicNeo-Medium", size: 19))
                + Text("\(dateformat.string(from: today))")
                    .font(.custom("AppleSDGothicNeo-Medium", size: 14))
                
            )
        }

    }
}

#Preview {
    ContentView()
}
