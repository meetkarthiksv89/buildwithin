//
//  NutritionSegmentedControl.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/31/25.
//

import SwiftUI

enum NutritionViewMode {
    case logFood
    case mealPlans
}

struct NutritionSegmentedControl: View {
    @Binding var selectedMode: NutritionViewMode
    
    var body: some View {
        HStack(spacing: 0) {
            // Log Food Button
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedMode = .logFood
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 14))
                    Text("Log Food")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .foregroundColor(selectedMode == .logFood ? .black : .appTextSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(selectedMode == .logFood ? Color.appPrimaryGreen : Color.clear)
                )
            }
            
            // Meal Plans Button
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedMode = .mealPlans
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "fork.knife")
                        .font(.system(size: 14))
                    Text("Meal Plans")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .foregroundColor(selectedMode == .mealPlans ? .black : .appTextSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(selectedMode == .mealPlans ? Color.appPrimaryGreen : Color.clear)
                )
            }
        }
        .padding(4)
        .background(Color.appCardBackground)
        .cornerRadius(10)
    }
}

#Preview {
    @Previewable @State var selectedMode: NutritionViewMode = .mealPlans
    
    VStack(spacing: 20) {
        NutritionSegmentedControl(selectedMode: $selectedMode)
            .padding()
    }
    .background(Color.appBackground)
}
