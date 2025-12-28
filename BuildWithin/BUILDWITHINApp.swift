//
//  BUILDWITHINApp.swift
//  BUILDWITHIN
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import SwiftUI

@main
struct BUILDWITHINApp: App {
    @StateObject private var repository = ProgramRepository()
    private let progressStore = ProgressStore()
    
    var body: some Scene {
        WindowGroup {
            ProgramsListView(repository: repository, progressStore: progressStore)
        }
    }
}
