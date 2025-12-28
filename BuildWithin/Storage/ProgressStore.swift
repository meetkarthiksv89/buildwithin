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
    
    func saveSetLog(programId: String, log: ExerciseSetLog) throws {
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
}
