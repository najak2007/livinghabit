//
//  View+Extension.swift
//  livinghabit
//
//  Created by najak on 4/24/25.
//

import SwiftUI

extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
