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
    
    init(exercises: [Exercise], programId: String, workoutDayId: String, progressStore: ProgressStoreProtocol) {
        self.exercises = exercises
        self.programId = programId
        self.workoutDayId = workoutDayId
        self.progressStore = progressStore
        loadExistingLogs()
    }
    
    private func loadExistingLogs() {
        let existingLogs = progressStore.getAllSetLogs(programId: programId)
        for log in existingLogs {
            setLogs[log.setId] = log
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
            try? progressStore.saveSetLog(programId: programId, log: log)
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
            try? progressStore.saveSetLog(programId: programId, log: log)
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
            try? progressStore.saveSetLog(programId: programId, log: log)
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
        let completion = WorkoutDayCompletion(
            workoutDayId: workoutDayId,
            completedAt: Date()
        )
        try progressStore.saveWorkoutDayCompletion(programId: programId, completion: completion)
    }
}
