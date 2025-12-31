//
//  MealDetail.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/31/25.
//

import Foundation

struct MealDetail: Codable, Identifiable {
    let id: String
    let mealType: MealType
    let name: String
    let macros: Macronutrients
    let calories: Double
    let imageURL: String?
    let ingredients: [MealIngredient]
    
    // Initialize from Meal with ingredients
    init(meal: Meal, ingredients: [MealIngredient]) {
        self.id = meal.id
        self.mealType = meal.mealType
        self.name = meal.name
        self.macros = meal.macros
        self.calories = meal.calories
        self.imageURL = meal.imageURL
        self.ingredients = ingredients
    }
}
