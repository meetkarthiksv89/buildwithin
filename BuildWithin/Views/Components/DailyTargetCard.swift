//
//  DailyTargetCard.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/31/25.
//

import SwiftUI

struct DailyTargetCard: View {
    let dailyTarget: DailyTarget
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("DAILY TARGET")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.appTextSecondary)
                .textCase(.uppercase)
            
            HStack {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(Int(dailyTarget.totalCalories).formatted(.number.grouping(.automatic)))")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.appTextPrimary)
                    Text("kcal")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(.appPrimaryGreen)
                }
                
                Spacer()
                
                Image(systemName: "flame.fill")
                    .foregroundColor(.appPrimaryGreen)
                    .font(.system(size: 20))
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                // Carbs Card
                VStack(alignment: .center, spacing: 4) {
                    Text("CARBS")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.macroCarbs.opacity(0.7))
                        .textCase(.uppercase)
                    Text("\(Int(dailyTarget.carbsGrams))g")
                        .font(.headline)
                        .foregroundColor(.macroCarbs)
                    Text("\(Int(dailyTarget.carbsPercentage))%")
                        .font(.caption2)
                        .foregroundColor(.macroCarbs.opacity(0.7))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .padding(.horizontal, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.macroCarbs.opacity(0.15))
                )
                
                // Fat Card
                VStack(alignment: .center, spacing: 4) {
                    Text("FAT")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.macroFat.opacity(0.7))
                        .textCase(.uppercase)
                    Text("\(Int(dailyTarget.fatGrams))g")
                        .font(.headline)
                        .foregroundColor(.macroFat)
                    Text("\(Int(dailyTarget.fatPercentage))%")
                        .font(.caption2)
                        .foregroundColor(.macroFat.opacity(0.7))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .padding(.horizontal, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.macroFat.opacity(0.15))
                )
                
                // Protein Card
                VStack(alignment: .center, spacing: 4) {
                    Text("PROTEIN")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.macroProtein.opacity(0.7))
                        .textCase(.uppercase)
                    Text("\(Int(dailyTarget.proteinGrams))g")
                        .font(.headline)
                        .foregroundColor(.macroProtein)
                    Text("\(Int(dailyTarget.proteinPercentage))%")
                        .font(.caption2)
                        .foregroundColor(.macroProtein.opacity(0.7))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .padding(.horizontal, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.macroProtein.opacity(0.15))
                )
            }
        }
        .padding(20)
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
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.appPrimaryGreen.opacity(0.3), lineWidth: 1)
        )
        .cornerRadius(16)
    }
}

#Preview {
    DailyTargetCard(dailyTarget: DailyTarget(
        totalCalories: 1591,
        macros: Macronutrients(carbs: 174, fat: 47, protein: 120)
    ))
    .background(Color.appBackground)
    .padding()
}
