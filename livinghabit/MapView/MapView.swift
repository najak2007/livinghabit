//
//  MapView.swift
//  livinghabit
//
//  Created by 오션블루 on 5/12/25.
//

import SwiftUI

struct MapView: View {
    @StateObject var viewModel = MapViewModel()
    
    var body: some View {
        WrapperView(view: viewModel.mapView)
            .ignoresSafeArea()
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
