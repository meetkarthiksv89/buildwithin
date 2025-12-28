//
//  Enums.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import Foundation

enum ProgramCategory: String, Codable {
    case strength
    case running
    case mobility
    case recovery
}

enum EquipmentType: String, Codable {
    case barbell
    case dumbbell
    case machine
    case bodyweight
    case kettlebell
}

enum MuscleGroup: String, Codable {
    case chest
    case back
    case shoulders
    case arms
    case legs
    case core
}
