//
//  CommonViewModel.swift
//  livinghabit
//
//  Created by 오션블루 on 5/15/25.
//

import Foundation
import SwiftUI

class CommonViewModel: NSObject, ObservableObject {
    @State var isBackButtonHidden: Bool = false
    
    override init() {}
}
