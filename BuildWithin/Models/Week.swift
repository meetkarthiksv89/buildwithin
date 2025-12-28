//
//  Week.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import Foundation

struct Week: Identifiable {
    let weekNumber: Int
    let days: [WorkoutDay]
    
    var id: Int {
        weekNumber
    }
    
    var totalDays: Int {
        days.count
    }
    
    func completedDaysCount(using isCompleted: (WorkoutDay) -> Bool) -> Int {
        days.filter { isCompleted($0) }.count
    }
    
    var completionPercentage: Double {
        guard totalDays > 0 else { return 0 }
        return Double(completedDaysCount(using: { _ in false })) / Double(totalDays)
    }
}
