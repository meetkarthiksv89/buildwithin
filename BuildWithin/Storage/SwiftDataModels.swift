//
//  SwiftDataModels.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import Foundation
import SwiftData

@Model
final class WorkoutSession {
    var id: UUID
    var programId: String
    var workoutDayId: String
    var startTime: Date
    var endTime: Date?
    
    @Relationship(deleteRule: .cascade, inverse: \SetLog.workoutSession)
    var setLogs: [SetLog] = []
    
    init(id: UUID = UUID(), programId: String, workoutDayId: String, startTime: Date = Date(), endTime: Date? = nil) {
        self.id = id
        self.programId = programId
        self.workoutDayId = workoutDayId
        self.startTime = startTime
        self.endTime = endTime
    }
}

@Model
final class SetLog {
    var id: UUID
    var exerciseId: String
    var setId: String
    var setNumber: Int
    var completedReps: Int?
    var completedWeight: Double?
    var isCompleted: Bool
    var completedAt: Date
    
    var workoutSession: WorkoutSession?
    
    init(id: UUID = UUID(), exerciseId: String, setId: String, setNumber: Int, completedReps: Int? = nil, completedWeight: Double? = nil, isCompleted: Bool = false, completedAt: Date = Date(), workoutSession: WorkoutSession? = nil) {
        self.id = id
        self.exerciseId = exerciseId
        self.setId = setId
        self.setNumber = setNumber
        self.completedReps = completedReps
        self.completedWeight = completedWeight
        self.isCompleted = isCompleted
        self.completedAt = completedAt
        self.workoutSession = workoutSession
    }
}
