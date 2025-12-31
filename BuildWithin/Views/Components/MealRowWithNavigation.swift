//
//  MealRowWithNavigation.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/31/25.
//

import SwiftUI

struct MealRowWithNavigation: View {
    let meal: Meal
    let nutritionPlan: NutritionPlanContent
    let showShuffleButton: Bool
    let onShuffleTap: () -> Void
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // Main content - tappable for navigation
            NavigationLink(destination: MealDetailView(
                mealDetail: nutritionPlan.mealDetail(for: meal)
            )) {
                MealRowMainContent(meal: meal)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Refresh button - separate from navigation
            if showShuffleButton {
                Button(action: {
                    onShuffleTap()
                }) {
                    Circle()
                        .fill(Color.appInactiveGray)
                        .frame(width: 24, height: 24)
                        .overlay {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.appTextPrimary)
                                .font(.system(size: 11))
                        }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(16)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.appPrimaryGreen.opacity(0.15),
                    Color.appCardBackground
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.appPrimaryGreen.opacity(0.2), lineWidth: 1)
        )
        .cornerRadius(16)
    }
}

struct MealRowMainContent: View {
    let meal: Meal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Top row: Meal type and calories
            HStack {
                Text(meal.mealType.displayName)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.appTextSecondary)
                    .textCase(.uppercase)
                
                Spacer()
                
                Text("\(Int(meal.calories)) kcal")
                    .font(.headline)
                    .foregroundColor(.appTextPrimary)
            }
            
            // Meal name and macros
            VStack(alignment: .leading, spacing: 8) {
                Text(meal.name)
                    .font(.headline)
                    .foregroundColor(.appTextPrimary)
                
                HStack(spacing: 12) {
                    // Carbs
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.macroCarbs)
                            .frame(width: 6, height: 6)
                        Text("\(Int(meal.macros.carbs))g C")
                            .font(.caption)
                            .foregroundColor(.appTextSecondary)
                    }
                    
                    // Fat
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.macroFat)
                            .frame(width: 6, height: 6)
                        Text("\(Int(meal.macros.fat))g F")
                            .font(.caption)
                            .foregroundColor(.appTextSecondary)
                    }
                    
                    // Protein
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.macroProtein)
                            .frame(width: 6, height: 6)
                        Text("\(Int(meal.macros.protein))g P")
                            .font(.caption)
                            .foregroundColor(.appTextSecondary)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}



#Preview {
    VStack(spacing: 16) {
        MealRowWithNavigation(
            meal: Meal(
                id: "test1",
                mealType: .breakfast,
                name: "Idli + Whey Protein",
                isDefault: true,
                macros: Macronutrients(carbs: 37, fat: 6, protein: 32),
                calories: 326,
                imageURL: nil
            ),
            nutritionPlan: NutritionPlanContent(
                nutritionPlan: NutritionPlan(
                    id: "test",
                    title: "Test",
                    subtitle: nil,
                    description: nil,
                    coverImageURL: nil,
                    isActive: true
                ),
                dailyTarget: DailyTarget(
                    totalCalories: 1591,
                    macros: Macronutrients(carbs: 174, fat: 47, protein: 120)
                ),
                meals: [],
                ingredients: []
            ),
            showShuffleButton: true,
            onShuffleTap: {}
        )
    }
    .background(Color.appBackground)
    .padding()
}
