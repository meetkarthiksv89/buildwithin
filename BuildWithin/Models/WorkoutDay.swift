//
//  WorkoutDay.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import Foundation

struct WorkoutDay: Codable, Identifiable {
    let id: String
    let programId: String
    let dayNumber: Int
    let title: String
    let description: String?
    let estimatedDurationMinutes: Int
    let isRestDay: Bool
}
