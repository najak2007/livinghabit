//
//  WrapperView.swift
//  livinghabit
//
//  Created by 오션블루 on 5/12/25.
//

import SwiftUI

public struct WrapperView<V: UIView>: UIViewRepresentable {
    public typealias UIViewType = V
    
    public var view: V
    
    public init(view: V) {
        self.view = view
    }
    
    public func makeUIView(context: Context) -> V {
        return view
    }
    
    public func updateUIView(_ uiView: V, context: Context) {}
}
