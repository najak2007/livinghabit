//
//  ToDoListView.swift
//  livinghabit
//
//  Created by 오션블루 on 6/24/25.
//

import SwiftUI

struct ToDoListView: View {
    
    var date: Date
    var location: ClockLocation
    
    var body: some View {
        Text(location.name)
    }
}
