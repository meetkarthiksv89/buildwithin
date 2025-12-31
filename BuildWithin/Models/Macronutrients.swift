//
//  Macronutrients.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/31/25.
//

import Foundation

struct Macronutrients: Codable {
    let carbs: Double      // grams
    let fat: Double        // grams
    let protein: Double    // grams
    
    var totalCalories: Double {
        (carbs * 4) + (fat * 9) + (protein * 4)
    }
    
    var carbsPercentage: Double {
        guard totalCalories > 0 else { return 0 }
        return (carbs * 4) / totalCalories * 100
    }
    
    var fatPercentage: Double {
        guard totalCalories > 0 else { return 0 }
        return (fat * 9) / totalCalories * 100
    }
    
    var proteinPercentage: Double {
        guard totalCalories > 0 else { return 0 }
        return (protein * 4) / totalCalories * 100
    }
}
