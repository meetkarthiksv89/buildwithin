//
//  DailyTarget.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/31/25.
//

import Foundation

struct DailyTarget: Codable {
    let totalCalories: Double
    let macros: Macronutrients
    
    // Convenience computed properties
    var carbsGrams: Double { macros.carbs }
    var fatGrams: Double { macros.fat }
    var proteinGrams: Double { macros.protein }
    
    var carbsPercentage: Double { macros.carbsPercentage }
    var fatPercentage: Double { macros.fatPercentage }
    var proteinPercentage: Double { macros.proteinPercentage }
}
