//
//  ProgramContent.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import Foundation

struct ProgramContent: Codable, Identifiable {
    let program: Program
    let workoutDays: [WorkoutDay]
    let exercises: [Exercise]
    
    var id: String {
        program.id
    }
}
