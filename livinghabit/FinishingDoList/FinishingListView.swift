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
    
    @ObservedObject private var mv = MapViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            List {
                ForEach(mv.locationInfoDatas, id: \.id) { locationListData in
                    VStack(alignment: .leading) {
                        Text("Date \(locationListData.date.yyyyMMdd) 위도 = \(locationListData.latitude) 경도 = \(locationListData.longitude)")
                    }
                }
            }
        }
    }
}
