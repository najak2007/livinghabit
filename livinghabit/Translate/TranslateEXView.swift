//
//  TranslateEXView.swift
//  livinghabit
//
//  Created by najak on 5/9/25.
//

import SwiftUI


struct TranslateEXView: View {
    var body: some View {
        VStack {
            SUWebView(url: URL(string: "https://www.google.com"))
        }
        .navigationBarHidden(true)
    }
}
