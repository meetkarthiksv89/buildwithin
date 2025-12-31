//
//  ExerciseHistoryViewModel.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/28/25.
//

import Foundation
import Combine

struct ExerciseSessionGroup {
    let session: WorkoutSession
    let sets: [SetLog]
}

@MainActor
class ExerciseHistoryViewModel: ObservableObject {
    @Published var sessionGroups: [ExerciseSessionGroup] = []
    @Published var isLoading: Bool = false
    
    private let exercise: Exercise
    private let progressStore: ProgressStoreProtocol
    private let allPrograms: [ProgramContent]
    
    init(exercise: Exercise, progressStore: ProgressStoreProtocol, allPrograms: [ProgramContent]) {
        self.exercise = exercise
        self.progressStore = progressStore
        self.allPrograms = allPrograms
        loadExerciseHistory()
    }
    
    func loadExerciseHistory() {
        isLoading = true
        
        // Get all set logs for this exercise
        let allSetLogs = progressStore.getAllSetLogsForExercise(exerciseId: exercise.id)
        
        // Group set logs by workout session
        var sessionMap: [UUID: [SetLog]] = [:]
        
        for setLog in allSetLogs {
            guard let sessionId = setLog.workoutSession?.id else { continue }
            if sessionMap[sessionId] == nil {
                sessionMap[sessionId] = []
            }
            sessionMap[sessionId]?.append(setLog)
        }
        
        // Create session groups
        var groups: [ExerciseSessionGroup] = []
        
        for (sessionId, sets) in sessionMap {
            // Get the workout session
            guard let session = progressStore.getWorkoutSession(id: sessionId) else { continue }
            
            // Sort sets by setNumber
            let sortedSets = sets.sorted { $0.setNumber < $1.setNumber }
            
            groups.append(ExerciseSessionGroup(session: session, sets: sortedSets))
        }
        
        // Sort groups by session start time (newest first)
        groups.sort { $0.session.startTime > $1.session.startTime }
        
        sessionGroups = groups
        isLoading = false
    }
    
    func getProgramName(for session: WorkoutSession) -> String {
        return allPrograms.first(where: { $0.program.id == session.programId })?.program.title ?? "Unknown Program"
    }
    
    func getWorkoutDayName(for session: WorkoutSession) -> String {
        guard let program = allPrograms.first(where: { $0.program.id == session.programId }) else {
            return "Day \(session.workoutDayId)"
        }
        
        if let workoutDay = program.workoutDays.first(where: { $0.id == session.workoutDayId }) {
            return workoutDay.title
        }
        
        return "Day \(session.workoutDayId)"
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
