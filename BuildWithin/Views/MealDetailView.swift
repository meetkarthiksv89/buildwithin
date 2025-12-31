//
//  MealDetailView.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/31/25.
//

import SwiftUI

struct MealDetailView: View {
    let mealDetail: MealDetail
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Meal Image Placeholder (if needed)
                    if mealDetail.imageURL != nil {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.appCardBackground)
                            .frame(height: 200)
                            .overlay {
                                Image(systemName: "fork.knife")
                                    .font(.system(size: 48))
                                    .foregroundColor(.appTextSecondary)
                            }
                            .padding(.horizontal)
                    }
                    
                    // Meal Title
                    Text(mealDetail.name)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.appTextPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Total Energy Section
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("TOTAL ENERGY")
                                .font(.caption)
                                .foregroundColor(.appTextSecondary)
                                .textCase(.uppercase)
                            
                            HStack(alignment: .firstTextBaseline, spacing: 4) {
                                Text("\(Int(mealDetail.calories))")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.appTextPrimary)
                                Text("kcals")
                                    .font(.system(size: 18))
                                    .foregroundColor(.appPrimaryGreen)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // TODO: Implement log meal action
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "plus")
                                    .font(.system(size: 16, weight: .bold))
                                Text("Log Meal")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(Color.appPrimaryGreen)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Macronutrient Breakdown Cards
                    HStack(spacing: 12) {
                        MacroCard(
                            title: "CARBS",
                            value: Int(mealDetail.macros.carbs),
                            percentage: Int(mealDetail.macros.carbsPercentage),
                            color: .macroCarbs
                        )
                        
                        MacroCard(
                            title: "FAT",
                            value: Int(mealDetail.macros.fat),
                            percentage: Int(mealDetail.macros.fatPercentage),
                            color: .macroFat
                        )
                        
                        MacroCard(
                            title: "PROTEIN",
                            value: Int(mealDetail.macros.protein),
                            percentage: Int(mealDetail.macros.proteinPercentage),
                            color: .macroProtein
                        )
                    }
                    .padding(.horizontal)
                    
                    // Ingredients Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Ingredients")
                                .font(.headline)
                                .foregroundColor(.appTextPrimary)
                            
                            Spacer()
                            
                            Text("\(mealDetail.ingredients.count) ITEMS")
                                .font(.caption)
                                .foregroundColor(.appTextSecondary)
                                .textCase(.uppercase)
                        }
                        .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            ForEach(mealDetail.ingredients) { ingredient in
                                IngredientRow(ingredient: ingredient)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MacroCard: View {
    let title: String
    let value: Int
    let percentage: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.3), lineWidth: 8)
                    .frame(width: 60, height: 60)
                
                Circle()
                    .trim(from: 0, to: CGFloat(percentage) / 100)
                    .stroke(color, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(-90))
                
                Text("\(percentage)%")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.appTextPrimary)
            }
            
            Text("\(value)g")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.appTextPrimary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.appTextSecondary)
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.appPrimaryGreen.opacity(0.2),
                    Color.appCardBackground
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.appPrimaryGreen.opacity(0.3), lineWidth: 1)
        )
        .cornerRadius(12)
    }
}

struct IngredientRow: View {
    let ingredient: MealIngredient
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(ingredient.name)
                    .font(.headline)
                    .foregroundColor(.appTextPrimary)
                
                if let description = ingredient.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.appTextSecondary)
                }
                
                HStack(spacing: 8) {
                    if ingredient.macros.carbs > 0 {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color.macroCarbs)
                                .frame(width: 6, height: 6)
                            Text("\(Int(ingredient.macros.carbs))g C")
                                .font(.caption)
                                .foregroundColor(.appTextSecondary)
                        }
                    }
                    
                    if ingredient.macros.fat > 0 {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color.macroFat)
                                .frame(width: 6, height: 6)
                            Text("\(Int(ingredient.macros.fat))g F")
                                .font(.caption)
                                .foregroundColor(.appTextSecondary)
                        }
                    }
                    
                    if ingredient.macros.protein > 0 {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color.macroProtein)
                                .frame(width: 6, height: 6)
                            Text("\(Int(ingredient.macros.protein))g P")
                                .font(.caption)
                                .foregroundColor(.appTextSecondary)
                        }
                    }
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(ingredient.quantity)
                    .font(.subheadline)
                    .foregroundColor(.appTextPrimary)
                
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.appPrimaryGreen)
                        .font(.system(size: 12))
                    Text("\(Int(ingredient.calories))")
                        .font(.subheadline)
                        .foregroundColor(.appTextSecondary)
                }
            }
        }
        .padding(16)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.appPrimaryGreen.opacity(0.2),
                    Color.appCardBackground
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.appPrimaryGreen.opacity(0.3), lineWidth: 1)
        )
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        MealDetailView(mealDetail: MealDetail(
            meal: Meal(
                id: "test",
                mealType: .breakfast,
                name: "Idli + Whey Protein",
                isDefault: true,
                macros: Macronutrients(carbs: 37, fat: 6, protein: 32),
                calories: 326,
                imageURL: nil
            ),
            ingredients: [
                MealIngredient(
                    id: "1",
                    mealId: "test",
                    name: "Sooji",
                    description: nil,
                    quantity: "40 g",
                    macros: Macronutrients(carbs: 32, fat: 0.7, protein: 5.3),
                    calories: 155
                ),
                MealIngredient(
                    id: "2",
                    mealId: "test",
                    name: "Veggies",
                    description: "Onion, Tomatoes, Green Pepper",
                    quantity: "50 g",
                    macros: Macronutrients(carbs: 4.5, fat: 0, protein: 0),
                    calories: 18
                )
            ]
        ))
    }
}
