//
//  MealPickerView.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/31/25.
//

import SwiftUI

struct MealPickerView: View {
    let mealType: MealType
    let mealOptions: [Meal]
    let currentMeal: Meal
    let onSelect: (Meal) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        VStack(spacing: 8) {
                            Text(mealType.displayName)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.appTextPrimary)
                            
                            Text("Select a meal option")
                                .font(.subheadline)
                                .foregroundColor(.appTextSecondary)
                        }
                        .padding(.top)
                        
                        // Meal Options List
                        VStack(spacing: 12) {
                            ForEach(mealOptions) { meal in
                                MealOptionCard(
                                    meal: meal,
                                    isSelected: meal.id == currentMeal.id,
                                    onSelect: {
                                        onSelect(meal)
                                        dismiss()
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
            }
            .navigationTitle("Meal Options")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.appPrimaryGreen)
                }
            }
        }
    }
}

struct MealOptionCard: View {
    let meal: Meal
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 16) {
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
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(Int(meal.calories)) kcal")
                        .font(.headline)
                        .foregroundColor(.appTextPrimary)
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.appPrimaryGreen)
                            .font(.system(size: 20))
                    }
                }
            }
            .padding(16)
            .background(
                Group {
                    if isSelected {
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.appPrimaryGreen.opacity(0.2),
                                Color.appCardBackground
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    } else {
                        Color.appCardBackground
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? Color.appPrimaryGreen : Color.clear,
                        lineWidth: isSelected ? 2 : 0
                    )
            )
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MealPickerView(
        mealType: .breakfast,
        mealOptions: [
            Meal(
                id: "meal_breakfast_01",
                mealType: .breakfast,
                name: "Idli + Whey Protein",
                isDefault: true,
                macros: Macronutrients(carbs: 37, fat: 6, protein: 32),
                calories: 326,
                imageURL: nil
            ),
            Meal(
                id: "meal_breakfast_02",
                mealType: .breakfast,
                name: "Dosa",
                isDefault: false,
                macros: Macronutrients(carbs: 40, fat: 8, protein: 8),
                calories: 280,
                imageURL: nil
            ),
            Meal(
                id: "meal_breakfast_03",
                mealType: .breakfast,
                name: "Poha",
                isDefault: false,
                macros: Macronutrients(carbs: 35, fat: 5, protein: 6),
                calories: 250,
                imageURL: nil
            )
        ],
        currentMeal: Meal(
            id: "meal_breakfast_01",
            mealType: .breakfast,
            name: "Idli + Whey Protein",
            isDefault: true,
            macros: Macronutrients(carbs: 37, fat: 6, protein: 32),
            calories: 326,
            imageURL: nil
        ),
        onSelect: { _ in }
    )
}
