//
//  NutritionPlanCard.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/31/25.
//

import SwiftUI

struct NutritionPlanCard: View {
    let nutritionPlan: NutritionPlan
    
    var body: some View {
        HStack(spacing: 16) {
            // Cover image placeholder
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.appCardBackground)
                .frame(width: 80, height: 80)
                .overlay {
                    Image(systemName: "fork.knife")
                        .foregroundColor(.appTextSecondary)
                        .font(.system(size: 32))
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(nutritionPlan.title)
                    .font(.headline)
                    .foregroundColor(.appTextPrimary)
                
                if let subtitle = nutritionPlan.subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.appLightGreen)
                }
            }
            
            Spacer()
        }
        .padding()
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
    NutritionPlanCard(nutritionPlan: NutritionPlan(
        id: "test",
        title: "Fat Loss Meal Plan",
        subtitle: "High Protein • Balanced Macros",
        description: nil,
        coverImageURL: nil,
        isActive: true
    ))
    .background(Color.appBackground)
    .padding()
}
