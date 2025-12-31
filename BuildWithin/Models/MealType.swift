//
//  MealType.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/31/25.
//

import Foundation

enum MealType: String, Codable, Identifiable {
    case morningPreWorkout = "morning_pre_workout"
    case breakfast = "breakfast"
    case lunch = "lunch"
    case dinner = "dinner"
    case snack = "snack"  // Optional, for future use
    
    var id: String {
        rawValue
    }
    
    var displayName: String {
        switch self {
        case .morningPreWorkout:
            return "MORNING PRE-WORKOUT"
        case .breakfast:
            return "BREAKFAST"
        case .lunch:
            return "LUNCH"
        case .dinner:
            return "DINNER"
        case .snack:
            return "SNACK"
        }
    }
}
