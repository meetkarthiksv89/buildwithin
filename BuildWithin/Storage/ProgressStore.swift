//
//  ProgressStore.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import Foundation

class ProgressStore: ProgressStoreProtocol {
    private let userDefaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }
    
    private func key(for programId: String) -> String {
        return "progress_\(programId)"
    }
    
    private func loadProgress(for programId: String) -> ProgramProgress {
        let key = key(for: programId)
        guard let data = userDefaults.data(forKey: key),
              let progress = try? decoder.decode(ProgramProgress.self, from: data) else {
            return ProgramProgress()
        }
        return progress
    }
    
    private func saveProgress(_ progress: ProgramProgress, for programId: String) throws {
        let key = key(for: programId)
        let data = try encoder.encode(progress)
        userDefaults.set(data, forKey: key)
    }
    
    // MARK: - WorkoutDayCompletion
    
    func saveWorkoutDayCompletion(programId: String, completion: WorkoutDayCompletion) throws {
        var progress = loadProgress(for: programId)
        progress.addCompletion(completion)
        try saveProgress(progress, for: programId)
    }
    
    func getWorkoutDayCompletion(programId: String, workoutDayId: String) -> WorkoutDayCompletion? {
        let progress = loadProgress(for: programId)
        return progress.workoutDayCompletions.first { $0.workoutDayId == workoutDayId }
    }
    
    func getAllCompletions(programId: String) -> [WorkoutDayCompletion] {
        let progress = loadProgress(for: programId)
        return progress.workoutDayCompletions
    }
    
    // MARK: - ExerciseSetLog
    
    func saveSetLog(programId: String, log: ExerciseSetLog, workoutSessionId: UUID?) throws {
        // For backward compatibility, ignore workoutSessionId
        var progress = loadProgress(for: programId)
        progress.addSetLog(log)
        try saveProgress(progress, for: programId)
    }
    
    func getSetLog(programId: String, setId: String) -> ExerciseSetLog? {
        let progress = loadProgress(for: programId)
        return progress.exerciseSetLogs[setId]
    }
    
    func getAllSetLogs(programId: String) -> [ExerciseSetLog] {
        let progress = loadProgress(for: programId)
        return Array(progress.exerciseSetLogs.values)
    }
    
    // MARK: - SwiftData Methods (not supported by UserDefaults implementation)
    
    func createWorkoutSession(programId: String, workoutDayId: String) throws -> WorkoutSession {
        throw NSError(domain: "ProgressStore", code: 1, userInfo: [NSLocalizedDescriptionKey: "WorkoutSession not supported by UserDefaults implementation"])
    }
    
    func getWorkoutSession(id: UUID) -> WorkoutSession? {
        return nil
    }
    
    func getSetLogsForExercise(exerciseId: String, programId: String, from startDate: Date?, to endDate: Date?) -> [SetLog] {
        // UserDefaults implementation doesn't support date filtering or SetLog
        return []
    }
    
    func getMostRecentSetLog(exerciseId: String, programId: String) -> SetLog? {
        // UserDefaults implementation doesn't support SetLog
        return nil
    }
    
    func getActiveWorkoutSession(programId: String, workoutDayId: String) -> WorkoutSession? {
        return nil
    }
    
    func finishWorkout(programId: String, workoutSessionId: UUID) throws {
        throw NSError(domain: "ProgressStore", code: 1, userInfo: [NSLocalizedDescriptionKey: "finishWorkout not supported by UserDefaults implementation"])
    }
    
    // MARK: - History Methods (not supported by UserDefaults implementation)
    
    func getAllWorkoutSessions() -> [WorkoutSession] {
        return []
    }
    
    func getWorkoutSessions(programId: String, workoutDayId: String) -> [WorkoutSession] {
        return []
    }
}
