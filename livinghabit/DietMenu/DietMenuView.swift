//
//  DietMenuView.swift
//  livinghabit
//
//  Created by najak on 6/26/25.
//

import SwiftUI
import RealmSwift

struct DietMenuView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.scenePhase) var scenePhase
    
    let manager = CaptureManager.instance
    
    var body: some View {
        VStack (spacing: 0) {
            Text("DietMenuView")
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
        .onAppear{
            manager.requestCameraPermission { isPermission in
                
            }
        }
    }
        
}
