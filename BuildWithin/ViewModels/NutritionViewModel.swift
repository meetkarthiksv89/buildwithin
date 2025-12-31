//
//  NutritionViewModel.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/31/25.
//

import Foundation
import Combine

@MainActor
class NutritionViewModel: ObservableObject {
    @Published var nutritionPlans: [NutritionPlanContent] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    let repository: NutritionRepository
    
    init(repository: NutritionRepository) {
        self.repository = repository
    }
    
    func loadNutritionPlans() async {
        isLoading = true
        errorMessage = nil
        
        do {
            nutritionPlans = try await repository.loadNutritionPlans()
            print("Successfully loaded \(nutritionPlans.count) nutrition plans")
        } catch {
            let errorDesc = error.localizedDescription
            errorMessage = errorDesc
            print("Error loading nutrition plans: \(error)")
            print("Error details: \(error)")
        }
        
        isLoading = false
    }
}
