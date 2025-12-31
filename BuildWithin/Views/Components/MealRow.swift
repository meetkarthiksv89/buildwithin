//
//  MealRow.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/31/25.
//

import SwiftUI

struct MealRow: View {
    let meal: Meal
    let showShuffleButton: Bool
    let onShuffleTap: () -> Void
    
    init(meal: Meal, showShuffleButton: Bool = true, onShuffleTap: @escaping () -> Void = {}) {
        self.meal = meal
        self.showShuffleButton = showShuffleButton
        self.onShuffleTap = onShuffleTap
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(meal.mealType.displayName)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.appTextSecondary)
                .textCase(.uppercase)
            
            HStack(alignment: .top) {
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
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    Text("\(Int(meal.calories)) kcal")
                        .font(.headline)
                        .foregroundColor(.appTextPrimary)
                    
                    HStack(spacing: 8) {
                        if showShuffleButton {
                            Button(action: {
                                onShuffleTap()
                            }) {
                                Circle()
                                    .fill(Color.appInactiveGray)
                                    .frame(width: 32, height: 32)
                                    .overlay {
                                        Image(systemName: "arrow.clockwise")
                                            .foregroundColor(.appTextPrimary)
                                            .font(.system(size: 14))
                                    }
                            }
                        }
                        
                        Button(action: {
                            // TODO: Implement add/log meal action
                        }) {
                            Circle()
                                .fill(Color.appPrimaryGreen)
                                .frame(width: 32, height: 32)
                                .overlay {
                                    Image(systemName: "plus")
                                        .foregroundColor(.black)
                                        .font(.system(size: 16, weight: .bold))
                                }
                        }
                    }
                }
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

#Preview {
    VStack(spacing: 16) {
        MealRow(meal: Meal(
            id: "test1",
            mealType: .morningPreWorkout,
            name: "Fruit of Choice",
            isDefault: true,
            macros: Macronutrients(carbs: 28, fat: 0, protein: 0),
            calories: 112,
            imageURL: nil
        ), showShuffleButton: false)
        
        MealRow(meal: Meal(
            id: "test2",
            mealType: .breakfast,
            name: "Idli + Whey Protein",
            isDefault: true,
            macros: Macronutrients(carbs: 37, fat: 6, protein: 32),
            calories: 326,
            imageURL: nil
        ), showShuffleButton: true)
    }
    .background(Color.appBackground)
    .padding()
}
