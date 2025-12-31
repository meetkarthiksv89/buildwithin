//
//  NutritionView.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import SwiftUI

struct NutritionView: View {
    @StateObject private var viewModel: NutritionViewModel
    
    init(repository: NutritionRepository) {
        _viewModel = StateObject(wrappedValue: NutritionViewModel(repository: repository))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .tint(.appPrimaryGreen)
                        Text("Loading nutrition plans...")
                            .foregroundColor(.appTextSecondary)
                    }
                } else if let errorMessage = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 48))
                            .foregroundColor(.appTextSecondary)
                        Text("Error loading nutrition plans")
                            .font(.headline)
                            .foregroundColor(.appTextPrimary)
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.appTextSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else {
                    VStack(spacing: 0) {
                        // Header
                        HStack {
                            Text("Nutrition")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.appTextPrimary)
                            
                            Spacer()
                        }
                        .padding()
                        
                        // Nutrition plans list
                        ScrollView {
                            VStack(spacing: 16) {
                                ForEach(viewModel.nutritionPlans) { planContent in
                                    NavigationLink(destination: MealsView(
                                        nutritionPlan: planContent
                                    )) {
                                        NutritionPlanCard(nutritionPlan: planContent.nutritionPlan)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .padding(.horizontal)
                            }
                            .padding(.vertical)
                        }
                    }
                }
            }
            .task {
                await viewModel.loadNutritionPlans()
            }
        }
    }
}

#Preview {
    NutritionView(repository: NutritionRepository())
        .environmentObject(NavigationState())
}
