//
//  MealsView.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/31/25.
//

import SwiftUI

struct MealsView: View {
    let nutritionPlan: NutritionPlanContent
    @State private var selectedMode: NutritionViewMode = .mealPlans
    @State private var activeMeals: [MealType: Meal] = [:]
    @State private var pickerMealType: MealType? = nil
    
    // Initialize active meals from default meals
    private func initializeActiveMeals() {
        let order: [MealType] = [.breakfast, .lunch, .eveningSnack, .dinner]
        for mealType in order {
            if let defaultMeal = nutritionPlan.defaultMeal(for: mealType) {
                activeMeals[mealType] = defaultMeal
            }
        }
    }
    
    // Sort meals by meal type order (using active meals)
    private var sortedMeals: [Meal] {
        let order: [MealType] = [.breakfast, .lunch, .eveningSnack, .dinner]
        return order.compactMap { activeMeals[$0] }
    }
    
    // Calculate daily target from selected meals
    private var calculatedDailyTarget: DailyTarget {
        let totals = activeMeals.values.reduce((calories: 0.0, carbs: 0.0, fat: 0.0, protein: 0.0)) { acc, meal in
            (acc.calories + meal.calories,
             acc.carbs + meal.macros.carbs,
             acc.fat + meal.macros.fat,
             acc.protein + meal.macros.protein)
        }
        return DailyTarget(
            totalCalories: totals.calories,
            macros: Macronutrients(carbs: totals.carbs, fat: totals.fat, protein: totals.protein)
        )
    }
    
    // Handle meal selection from picker
    private func handleMealSelection(_ meal: Meal) {
        activeMeals[meal.mealType] = meal
    }
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Segmented Control - hidden in meal plans view
                    if selectedMode != .mealPlans {
                        NutritionSegmentedControl(selectedMode: $selectedMode)
                            .padding(.horizontal)
                            .padding(.top, 8)
                    }
                    
                    if selectedMode == .mealPlans {
                        // Daily Target Card
                        DailyTargetCard(dailyTarget: calculatedDailyTarget)
                            .padding(.horizontal)
                        
                        // Meals List
                        VStack(spacing: 16) {
                            ForEach(sortedMeals) { meal in
                                MealRowWithNavigation(
                                    meal: meal,
                                    nutritionPlan: nutritionPlan,
                                    showShuffleButton: nutritionPlan.mealOptions(for: meal.mealType).count > 1,
                                    onShuffleTap: {
                                        pickerMealType = meal.mealType
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    } else {
                        // Log Food View (placeholder)
                        VStack(spacing: 16) {
                            Image(systemName: "list.bullet")
                                .font(.system(size: 64))
                                .foregroundColor(.appTextSecondary)
                            
                            Text("Log Food")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.appTextPrimary)
                            
                            Text("Coming soon...")
                                .font(.subheadline)
                                .foregroundColor(.appTextSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                    }
                }
            }
        }
        .navigationTitle("Nutrition")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            if activeMeals.isEmpty {
                initializeActiveMeals()
            }
        }
        .sheet(item: $pickerMealType) { mealType in
            if let currentMeal = activeMeals[mealType] {
                MealPickerView(
                    mealType: mealType,
                    mealOptions: nutritionPlan.mealOptions(for: mealType),
                    currentMeal: currentMeal,
                    onSelect: handleMealSelection
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        MealsView(nutritionPlan: NutritionPlanContent(
            nutritionPlan: NutritionPlan(
                id: "test",
                title: "Fat Loss Meal Plan",
                subtitle: "High Protein",
                description: nil,
                coverImageURL: nil,
                isActive: true
            ),
            dailyTarget: DailyTarget(
                totalCalories: 1591,
                macros: Macronutrients(carbs: 174, fat: 47, protein: 120)
            ),
            meals: [
                Meal(
                    id: "test1",
                    mealType: .breakfast,
                    name: "Test Breakfast",
                    isDefault: true,
                    macros: Macronutrients(carbs: 37, fat: 6, protein: 32),
                    calories: 326,
                    imageURL: nil
                )
            ],
            ingredients: []
        ))
    }
}
