//
//  InfiniteHorizontalListView.swift
//  livinghabit
//
//  Created by 오션블루 on 5/30/25.
//

import SwiftUI
import Foundation

class InfiniteScrollViewModel: ObservableObject {
    @Published var items = [String]()
    private var isLoading = false

    init() {
        loadMoreItems()
    }

    func loadMoreItems() {
        guard !isLoading else { return }
        isLoading = true
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let moreItems = (self.items.count..<self.items.count + 20).map { "Item \($0)" }
            DispatchQueue.main.async {
                self.items.append(contentsOf: moreItems)
                self.isLoading = false
            }
        }
    }
}

struct InfiniteHorizontalListView: View {
    @StateObject private var viewModel = InfiniteScrollViewModel()

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(viewModel.items, id: \.self) { item in
                    Text(item)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                        .onAppear {
                            if item == viewModel.items.last {
                                viewModel.loadMoreItems()
                            }
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}
