//
//  TimeListView.swift
//  livinghabit
//
//  Created by najak on 6/10/25.
//

import SwiftUI
import Foundation
import MapKit

struct TimeListView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {

            
            List {
                
            }
            .environment(\.defaultMinListRowHeight, 70)
        }
        .overlay {
            VStack {
                HStack {
                    Spacer()

                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image("talk_close")
                    })
                }
                .padding(.horizontal, 15)
                .padding(.vertical , 0)
                .background(Color.clear)

                Spacer()
            }
        }
    }
}
