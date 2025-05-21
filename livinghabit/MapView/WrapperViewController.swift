//
//  WrapperViewController.swift
//  livinghabit
//
//  Created by 오션블루 on 5/12/25.
//

import SwiftUI

public struct WrapperViewController<V: UIViewController>: UIViewControllerRepresentable {
    public typealias UIViewType = V
    
    public var viewController: V
    
    public init(viewController: V) {
        self.viewController = viewController
    }
    
    public func makeUIViewController(context: Context) -> V {
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: V, context: Context) {
        
    }
}
