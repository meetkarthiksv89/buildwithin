//
//  NavigationState.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/28/25.
//

import SwiftUI
import Combine

class NavigationState: ObservableObject {
    @Published var stackId = UUID()
    
    func popToRoot() {
        stackId = UUID()
    }
}
