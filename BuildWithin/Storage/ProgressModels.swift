//
//  ProgressModels.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import Foundation

struct WorkoutDayCompletion: Codable {
    let workoutDayId: String
    let completedAt: Date
}

struct ExerciseSetLog: Codable {
    let exerciseId: String
    let setId: String
    var setNumber: Int?
    var completedReps: Int?
    var completedWeight: Double?
    var isCompleted: Bool
}

struct ProgramProgress: Codable {
    var workoutDayCompletions: [WorkoutDayCompletion] = []
    var exerciseSetLogs: [String: ExerciseSetLog] = [:] // Keyed by setId
    
    mutating func addCompletion(_ completion: WorkoutDayCompletion) {
        workoutDayCompletions.removeAll { $0.workoutDayId == completion.workoutDayId }
        workoutDayCompletions.append(completion)
    }
    
    mutating func addSetLog(_ log: ExerciseSetLog) {
        exerciseSetLogs[log.setId] = log
    }
}
