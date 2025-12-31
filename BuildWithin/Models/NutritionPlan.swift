//
//  NutritionPlan.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/31/25.
//

import Foundation

struct NutritionPlan: Codable, Identifiable {
    let id: String
    let title: String                // e.g., "Fat Loss Meal Plan"
    let subtitle: String?            // Optional subtitle
    let description: String?         // Optional description
    let coverImageURL: String?       // Optional cover image
    let isActive: Bool               // Whether this plan is active
}
