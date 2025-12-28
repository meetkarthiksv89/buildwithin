//
//  ExerciseSet.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import Foundation

struct ExerciseSet: Codable, Identifiable {
    let id: String
    let setNumber: Int
    let targetReps: Int?
    let targetWeight: Double?
}
