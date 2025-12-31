//
//  Exercise.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import Foundation

struct Exercise: Codable, Identifiable {
    let id: String
    let workoutDayId: String
    let name: String
    let order: Int
    let equipment: EquipmentType
    let restSeconds: Int
    let targetMuscleGroups: [MuscleGroup]
    let sets: [ExerciseSet]
    let videoLink: String?
}
