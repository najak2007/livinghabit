//
//  FinishingListView.swift
//  livinghabit
//
//  Created by 오션블루 on 4/29/25.
//

import SwiftUI
import RealmSwift

struct FinishingListView: View {
    @ObservedObject private var viewModel = FinishingViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            List {
                ForEach(viewModel.toDoLists, id: \.id) { ToDoListData in
                    
                }
            }
        }
    }
}
