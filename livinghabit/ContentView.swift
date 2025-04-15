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
                NavigationLink(destination: Text ("Detail View 1")) {
                    Text("Link 1")
                }
                
                NavigationLink(destination: Text("Detail View 2")) {
                    Text("Link 2")
                }
                
                NavigationLink(destination: Text("Detail View 3")) {
                    Text("Link 3")
                }
            }
            .navigationTitle("오늘 [\(dateformat.string(from: today))]")
        }
    }
}

#Preview {
    ContentView()
}
