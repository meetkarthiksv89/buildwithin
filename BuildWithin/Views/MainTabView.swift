//
//  MainTabView.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @StateObject private var repository = ProgramRepository()
    @StateObject private var nutritionRepository = NutritionRepository()
    @StateObject private var navigationState = NavigationState()
    @Environment(\.modelContext) private var modelContext
    
    private var progressStore: ProgressStoreProtocol {
        SwiftDataProgressStore(modelContext: modelContext)
    }
    
    var body: some View {
        TabView {
            ProgramsListView(repository: repository, progressStore: progressStore)
                .tabItem {
                    Label("Training", systemImage: "dumbbell.fill")
                }
            
            NutritionView(repository: nutritionRepository)
                .tabItem {
                    Label("Nutrition", systemImage: "fork.knife")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .tint(.appPrimaryGreen)
        .environmentObject(navigationState)
    }
}

#Preview {
    MainTabView()
}
