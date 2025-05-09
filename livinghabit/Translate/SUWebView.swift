//
//  SUWebView.swift
//  livinghabit
//
//  Created by najak on 5/9/25.
//

import SwiftUI
import WebKit

struct SUWebView: UIViewRepresentable {
    var url: URL?
    var webView: WKWebView
    
    init(url: URL? = nil) {
        self.url = url
        self.webView = WKWebView()
    }
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = url else {
            return webView
        }
        
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        return
    }
}
