//
//  HorizontalListView.swift
//  livinghabit
//
//  Created by najak on 5/30/25.
//

import Foundation
import SwiftUI


struct LocationItemView: View {
    var item: String
    
    var body: some View {
        VStack {
            Image(systemName: "star")
                .resizable()
                .frame(width: 20, height: 20)
                .padding()
            Text(item)
                .font(.headline)
        }
        .background(Color.gray.opacity(0.3))
        .cornerRadius(10)
        .padding(5)
    }
}

struct HorizontalListView: View {
    let items = Array(1...20).map { "Item \($0)" }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(items, id: \.self) { item in
                    LocationItemView(item: item)
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 100)
    }
}

