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
    @State private var threeMeals: [String] = ["아침", "점심", "저녁", "간식"]
    @StateObject private var viewModel: DietMenuViewModel = DietMenuViewModel()
    
    @State private var selectedMeal: DietMenu?
    @State private var editedMeal: String = ""
    
    
    let manager = CaptureManager.instance
    
    var body: some View {
        List {
            ForEach(threeMeals, id: \.self) { meal in
                Section(header: ListHeader(headerTitle: meal)) {
                    ForEach(viewModel.mealLists, id: \.id) { meals in
                        if meal == meals.meal {
                            HStack {
                                VStack(alignment: .leading) {
                                    InputView(inputText: meals.food, originalText: meals.food, inputHandler: { inputText in
                                        if !inputText.isEmpty {
                                            viewModel.updateMealList(dietMenu: meals, newFoodStr: inputText)
                                        }
                                    })
                                }
                                .onTapGesture {
                                    self.endTextEditing()
                                    selectedMeal = meals
                                    editedMeal = meals.food
                                }
                            }
                        }
                    }
                    .onDelete(perform: viewModel.deleteMealList)
                    .onMove(perform: viewModel.moveList)
                }
            }
        }.environment(\.defaultMinListRowHeight, 70)
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
