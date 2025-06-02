//
//  ToDoListHeader.swift
//  livinghabit
//
//  Created by 오션블루 on 6/2/25.
//

import Foundation
import SwiftUI

struct ToDoListHeader: View {
    @Environment(\.colorScheme) var colorScheme
    var headerTitle: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(headerTitle)
                .font(.custom("AppleSDGothicNeo-Bold", size: 20))
                .foregroundColor(colorScheme == .dark ? Color(hex: "#666666") : Color(hex: "#666666"))
        }
    }
}
