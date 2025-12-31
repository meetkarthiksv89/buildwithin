//
//  ProgressStoreProtocol.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import Foundation

protocol ProgressStoreProtocol {
    func saveWorkoutDayCompletion(programId: String, completion: WorkoutDayCompletion) throws
    func getWorkoutDayCompletion(programId: String, workoutDayId: String) -> WorkoutDayCompletion?
    func getAllCompletions(programId: String) -> [WorkoutDayCompletion]
    
    func saveSetLog(programId: String, log: ExerciseSetLog, workoutSessionId: UUID?) throws
    func getSetLog(programId: String, setId: String) -> ExerciseSetLog?
    func getAllSetLogs(programId: String) -> [ExerciseSetLog]
    
    // New SwiftData methods
    func createWorkoutSession(programId: String, workoutDayId: String) throws -> WorkoutSession
    func getWorkoutSession(id: UUID) -> WorkoutSession?
    func getSetLogsForExercise(exerciseId: String, programId: String, from startDate: Date?, to endDate: Date?) -> [SetLog]
    func getMostRecentSetLog(exerciseId: String, programId: String) -> SetLog?
    func getActiveWorkoutSession(programId: String, workoutDayId: String) -> WorkoutSession?
    func finishWorkout(programId: String, workoutSessionId: UUID) throws
    
    // History methods
    func getAllWorkoutSessions() -> [WorkoutSession]
    func getWorkoutSessions(programId: String, workoutDayId: String) -> [WorkoutSession]
}
