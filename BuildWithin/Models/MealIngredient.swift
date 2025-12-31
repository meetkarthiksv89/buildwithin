//
//  MealIngredient.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/31/25.
//

import Foundation

struct MealIngredient: Codable, Identifiable {
    let id: String
    let mealId: String               // Reference to parent meal (like workoutDayId in Exercise)
    let name: String
    let description: String?        // Optional: e.g., "Onion, Tomatoes, Green Pepper"
    let quantity: String            // e.g., "40 g", "1 scoop"
    let macros: Macronutrients
    let calories: Double
    
    // Computed property for total calories (should match macros calculation)
    var calculatedCalories: Double {
        macros.totalCalories
    }
}
