//
//  View+Extension.swift
//  livinghabit
//
//  Created by najak on 4/24/25.
//

import SwiftUI

struct ClearBackgroundView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

struct ClearBackgroundViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.4, *) {
            content
                .presentationBackground(.clear)
        } else {
            content
                .background(ClearBackgroundView())
        }
    }
}


extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func clearModalBackground() -> some View {
        self.modifier(ClearBackgroundViewModifier())
    }
}
