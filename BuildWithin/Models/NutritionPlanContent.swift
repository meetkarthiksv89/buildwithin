//
//  NutritionPlanContent.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/31/25.
//

import Foundation

struct NutritionPlanContent: Codable, Identifiable {
    let nutritionPlan: NutritionPlan
    let dailyTarget: DailyTarget
    let meals: [Meal]                // List of meals for the day
    let ingredients: [MealIngredient] // All ingredients (referenced by mealId)
    
    var id: String {
        nutritionPlan.id
    }
    
    // Group meals by type for easier access
    func meals(for type: MealType) -> [Meal] {
        meals.filter { $0.mealType == type }
    }
    
    // Get all meal options for a specific meal type
    func mealOptions(for type: MealType) -> [Meal] {
        meals.filter { $0.mealType == type }
    }
    
    // Get the default/active meal for a meal type
    func defaultMeal(for type: MealType) -> Meal? {
        meals.first { $0.mealType == type && $0.isDefault }
    }
    
    // Get all default meals (one per type)
    var defaultMeals: [Meal] {
        let order: [MealType] = [.morningPreWorkout, .breakfast, .lunch, .dinner, .snack]
        return order.compactMap { defaultMeal(for: $0) }
    }
    
    // Get ingredients for a specific meal
    func ingredients(for mealId: String) -> [MealIngredient] {
        ingredients.filter { $0.mealId == mealId }
    }
    
    // Create MealDetail from a Meal
    func mealDetail(for meal: Meal) -> MealDetail {
        MealDetail(
            meal: meal,
            ingredients: ingredients(for: meal.id)
        )
    }
    
    // Verify daily target matches sum of meals
    var totalMealCalories: Double {
        meals.reduce(0) { $0 + $1.calories }
    }
}
