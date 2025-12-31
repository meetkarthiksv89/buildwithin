//
//  NutritionRepository.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/31/25.
//

import Foundation
import Combine

@MainActor
class NutritionRepository: ObservableObject {
    private let bundle: Bundle
    
    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }
    
    func loadNutritionPlans() async throws -> [NutritionPlanContent] {
        // Try loading with subdirectory first, then without
        var indexURL = bundle.url(forResource: "nutrition_index", withExtension: "json", subdirectory: "Nutrition")
        if indexURL == nil {
            indexURL = bundle.url(forResource: "nutrition_index", withExtension: "json")
        }
        
        guard let indexURL = indexURL else {
            // List all JSON files in bundle for debugging
            if let resourcePath = bundle.resourcePath {
                print("Available resources: \(String(describing: try? FileManager.default.contentsOfDirectory(atPath: resourcePath)))")
            }
            throw NutritionRepositoryError.indexNotFound
        }
        
        let indexData = try Data(contentsOf: indexURL)
        let index = try JSONDecoder().decode(NutritionIndex.self, from: indexData)
        
        // Load each nutrition plan file
        var plans: [NutritionPlanContent] = []
        
        for fileName in index.nutritionPlanFiles {
            let baseName = fileName.replacingOccurrences(of: ".json", with: "")
            var planURL = bundle.url(forResource: baseName, withExtension: "json", subdirectory: "Nutrition")
            
            if planURL == nil {
                planURL = bundle.url(forResource: baseName, withExtension: "json")
            }
            
            guard let planURL = planURL else {
                print("Warning: Could not find nutrition plan file: \(fileName)")
                continue
            }
            
            let planData = try Data(contentsOf: planURL)
            let planContent = try JSONDecoder().decode(NutritionPlanContent.self, from: planData)
            plans.append(planContent)
        }
        
        return plans
    }
    
    func loadNutritionPlan() async throws -> NutritionPlanContent {
        let plans = try await loadNutritionPlans()
        
        // Return the active plan
        if let activePlan = plans.first(where: { $0.nutritionPlan.isActive }) {
            return activePlan
        }
        
        // If no active plan found, throw error
        throw NutritionRepositoryError.noActivePlan
    }
}

enum NutritionRepositoryError: LocalizedError {
    case indexNotFound
    case nutritionPlanFileNotFound(String)
    case noActivePlan
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .indexNotFound:
            return "Nutrition index file not found"
        case .nutritionPlanFileNotFound(let fileName):
            return "Nutrition plan file not found: \(fileName)"
        case .noActivePlan:
            return "No active nutrition plan found"
        case .decodingError(let error):
            return "Failed to decode nutrition plan: \(error.localizedDescription)"
        }
    }
}
