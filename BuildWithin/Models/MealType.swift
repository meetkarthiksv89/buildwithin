//
//  MealType.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/31/25.
//

import Foundation

enum MealType: String, Codable, Identifiable {
    case breakfast = "breakfast"
    case lunch = "lunch"
    case eveningSnack = "evening_snack"
    case dinner = "dinner"
    
    var id: String {
        rawValue
    }
    
    var displayName: String {
        switch self {
        case .breakfast:
            return "BREAKFAST"
        case .lunch:
            return "LUNCH"
        case .eveningSnack:
            return "EVENING SNACK"
        case .dinner:
            return "DINNER"
        }
    }
}
