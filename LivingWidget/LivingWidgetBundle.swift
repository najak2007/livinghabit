//
//  LivingWidgetBundle.swift
//  LivingWidget
//
//  Created by najak on 6/11/25.
//

import WidgetKit
import SwiftUI

@main
struct LivingWidgetBundle: WidgetBundle {
    var body: some Widget {
        LivingWidget()
        LivingWidgetControl()
        LivingWidgetLiveActivity()
    }
}
