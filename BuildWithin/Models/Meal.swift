//
//  Meal.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/31/25.
//

import Foundation

struct Meal: Codable, Identifiable {
    let id: String
    let mealType: MealType
    let name: String                 // e.g., "Idli + Whey Protein"
    let isDefault: Bool              // Marks default/active meal for this type
    let macros: Macronutrients
    let calories: Double             // Total calories for the meal
    let imageURL: String?            // Optional meal image
    
    // Computed property
    var calculatedCalories: Double {
        macros.totalCalories
    }
}
