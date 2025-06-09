//
//  SearchBar.swift
//  livinghabit
//
//  Created by najak on 6/8/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    var searchHandler: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            HStack {
                Button(action: {
                    if let handler = self.searchHandler {
                        handler()
                    }
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
                
                if !text.isEmpty {
                    Button(action: {
                        self.text = ""
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
