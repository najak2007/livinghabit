//
//  ContentView.swift
//  watchLivinghabit Watch App
//
//  Created by 오션블루 on 6/10/25.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        VStack {
            LocationDetailsView(location: ClockLocation.locationSeoul)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
