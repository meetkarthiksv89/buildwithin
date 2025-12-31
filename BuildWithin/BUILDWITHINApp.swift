//
//  BUILDWITHINApp.swift
//  BUILDWITHIN
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import SwiftUI
import SwiftData

@main
struct BUILDWITHINApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: [WorkoutSession.self, SetLog.self])
    }
}
