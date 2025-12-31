//
//  ActiveWorkoutViewModel.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import Foundation
import Combine

@MainActor
class ActiveWorkoutViewModel: ObservableObject {
    @Published var currentExerciseIndex: Int = 0
    @Published var exercises: [Exercise]
    @Published var setLogs: [String: ExerciseSetLog] = [:]
    @Published var workoutStartTime: Date = Date()
    
    private let progressStore: ProgressStoreProtocol
    private let programId: String
    private let workoutDayId: String
    private var workoutSessionId: UUID?
    
    var currentExercise: Exercise? {
        guard currentExerciseIndex >= 0 && currentExerciseIndex < exercises.count else {
            return nil
        }
        return exercises[currentExerciseIndex]
    }
    
    var canGoToPrevious: Bool {
        return currentExerciseIndex > 0
    }
    
    var canGoToNext: Bool {
        return currentExerciseIndex < exercises.count - 1
    }
    
    var isLastExercise: Bool {
        return currentExerciseIndex == exercises.count - 1
    }
    
    var sessionId: UUID? {
        return workoutSessionId
    }
    
    init(exercises: [Exercise], programId: String, workoutDayId: String, progressStore: ProgressStoreProtocol) {
        self.exercises = exercises
        self.programId = programId
        self.workoutDayId = workoutDayId
        self.progressStore = progressStore
        
        // Create workout session
        do {
            let session = try progressStore.createWorkoutSession(programId: programId, workoutDayId: workoutDayId)
            workoutSessionId = session.id
            workoutStartTime = session.startTime
            
            // Load previous values for each exercise
            loadPreviousWorkoutValues()
        } catch {
            print("Error creating workout session: \(error)")
        }
    }
    
    private func loadPreviousWorkoutValues() {
        // For each exercise, get the most recent set log and pre-populate values
        for exercise in exercises {
            // Try to get the most recent log for this exercise
            if let mostRecentLog = progressStore.getMostRecentSetLog(exerciseId: exercise.id, programId: programId) {
                // Pre-populate all sets of this exercise with the previous values
                // This gives users a starting point based on their last performance
                for set in exercise.sets {
                    // Check if we already have a log for this specific setId (from current session)
                    if setLogs[set.id] == nil {
                        let previousLog = ExerciseSetLog(
                            exerciseId: exercise.id,
                            setId: set.id,
                            completedReps: mostRecentLog.completedReps,
                            completedWeight: mostRecentLog.completedWeight,
                            isCompleted: false // Don't mark as completed, just pre-populate values
                        )
                        setLogs[set.id] = previousLog
                    }
                }
            }
        }
    }
    
    func toggleSetCompletion(setId: String, exerciseId: String) {
        if var existingLog = setLogs[setId] {
            existingLog.isCompleted.toggle()
            setLogs[setId] = existingLog
        } else {
            // Create new log
            let newLog = ExerciseSetLog(
                exerciseId: exerciseId,
                setId: setId,
                completedReps: nil,
                completedWeight: nil,
                isCompleted: true
            )
            setLogs[setId] = newLog
        }
        
        // Save immediately
        if let log = setLogs[setId] {
            try? progressStore.saveSetLog(programId: programId, log: log, workoutSessionId: workoutSessionId)
        }
    }
    
    func updateSetReps(setId: String, exerciseId: String, reps: Int?) {
        if var existingLog = setLogs[setId] {
            existingLog.completedReps = reps
            setLogs[setId] = existingLog
        } else {
            let newLog = ExerciseSetLog(
                exerciseId: exerciseId,
                setId: setId,
                completedReps: reps,
                completedWeight: nil,
                isCompleted: false
            )
            setLogs[setId] = newLog
        }
        
        if let log = setLogs[setId] {
            try? progressStore.saveSetLog(programId: programId, log: log, workoutSessionId: workoutSessionId)
        }
    }
    
    func updateSetWeight(setId: String, exerciseId: String, weight: Double?) {
        if var existingLog = setLogs[setId] {
            existingLog.completedWeight = weight
            setLogs[setId] = existingLog
        } else {
            let newLog = ExerciseSetLog(
                exerciseId: exerciseId,
                setId: setId,
                completedReps: nil,
                completedWeight: weight,
                isCompleted: false
            )
            setLogs[setId] = newLog
        }
        
        if let log = setLogs[setId] {
            try? progressStore.saveSetLog(programId: programId, log: log, workoutSessionId: workoutSessionId)
        }
    }
    
    func isSetCompleted(setId: String) -> Bool {
        return setLogs[setId]?.isCompleted ?? false
    }
    
    func getSetLog(setId: String) -> ExerciseSetLog? {
        return setLogs[setId]
    }
    
    func nextExercise() {
        guard canGoToNext else { return }
        currentExerciseIndex += 1
    }
    
    func previousExercise() {
        guard canGoToPrevious else { return }
        currentExerciseIndex -= 1
    }
    
    func finishWorkout() throws {
        guard let sessionId = workoutSessionId else {
            throw NSError(domain: "ActiveWorkoutViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "No workout session found"])
        }
        
        // Finish the workout session
        try progressStore.finishWorkout(programId: programId, workoutSessionId: sessionId)
        
        // Also save completion for backward compatibility
        let completion = WorkoutDayCompletion(
            workoutDayId: workoutDayId,
            completedAt: Date()
        )
        try progressStore.saveWorkoutDayCompletion(programId: programId, completion: completion)
    }
}
