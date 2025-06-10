//
//  SearchBar.swift
//  livinghabit
//
//  Created by najak on 6/8/25.
//

import SwiftUI
import CoreLocation

struct SearchBar: View {
    @Binding var text: String
    @Binding var placemarkMenu: [CLPlacemark]

    
    var searchHandler: (() -> Void)? = nil
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            HStack {
                Button(action: {
                    if let handler = self.searchHandler {
                        handler()
                    }
                    isFocused = false
                }) {
                    Image(systemName: "magnifyingglass")
                }
                
                TextField("Search", text: $text)
                    .padding()
                    .cornerRadius(8)
                    .submitLabel(.search)
                    .onSubmit {
                        if let searchHandler = self.searchHandler {
                            searchHandler()
                        }
                    }
                    .focused($isFocused)
                
                if placemarkMenu.count > 0 {
                    Menu {
                        ForEach(placemarkMenu, id: \.self) { placemark in
                            Button(placemark.name ?? "") {
                                
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                }
                
                if !text.isEmpty {
                    Button(action: {
                        self.text = ""
                        self.placemarkMenu.removeAll()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                    }
                } else {
                    EmptyView()
                }
            }
            .frame(height: 40)
            .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
        }
        .padding(.horizontal)
    }
}
