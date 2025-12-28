//
//  MainTabView.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var repository = ProgramRepository()
    private let progressStore = ProgressStore()
    
    var body: some View {
        TabView {
            ProgramsListView(repository: repository, progressStore: progressStore)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            NutritionView()
                .tabItem {
                    Label("Nutrition", systemImage: "fork.knife")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .tint(.appPrimaryGreen)
    }
}

#Preview {
    MainTabView()
}
