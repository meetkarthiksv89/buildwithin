//
//  SwiftDataProgressStore.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import Foundation
import SwiftData

@MainActor
class SwiftDataProgressStore: ProgressStoreProtocol {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - WorkoutDayCompletion (legacy support)
    
    func saveWorkoutDayCompletion(programId: String, completion: WorkoutDayCompletion) throws {
        // For legacy support, we can store this as a WorkoutSession with endTime set
        // Or create a simple completion record - keeping it simple for now
        // This maintains backward compatibility
    }
    
    func getWorkoutDayCompletion(programId: String, workoutDayId: String) -> WorkoutDayCompletion? {
        // Find the most recent completed session for this workout day
        let descriptor = FetchDescriptor<WorkoutSession>(
            predicate: #Predicate<WorkoutSession> { session in
                session.programId == programId && session.workoutDayId == workoutDayId && session.endTime != nil
            },
            sortBy: [SortDescriptor(\.startTime, order: .reverse)]
        )
        
        if let session = try? modelContext.fetch(descriptor).first, let endTime = session.endTime {
            return WorkoutDayCompletion(workoutDayId: workoutDayId, completedAt: endTime)
        }
        return nil
    }
    
    func getAllCompletions(programId: String) -> [WorkoutDayCompletion] {
        let descriptor = FetchDescriptor<WorkoutSession>(
            predicate: #Predicate<WorkoutSession> { session in
                session.programId == programId && session.endTime != nil
            },
            sortBy: [SortDescriptor(\.startTime, order: .reverse)]
        )
        
        guard let sessions = try? modelContext.fetch(descriptor) else {
            return []
        }
        
        var completions: [WorkoutDayCompletion] = []
        var seenDays: Set<String> = []
        
        for session in sessions {
            if !seenDays.contains(session.workoutDayId), let endTime = session.endTime {
                completions.append(WorkoutDayCompletion(workoutDayId: session.workoutDayId, completedAt: endTime))
                seenDays.insert(session.workoutDayId)
            }
        }
        
        return completions
    }
    
    // MARK: - ExerciseSetLog (legacy support)
    
    func saveSetLog(programId: String, log: ExerciseSetLog, workoutSessionId: UUID?) throws {
        if let sessionId = workoutSessionId {
            // New way - save with session
            try saveSetLogWithSession(programId: programId, log: log, workoutSessionId: sessionId)
        } else {
            // Legacy way - try to find active session for this program
            // We need workoutDayId but don't have it, so try to find any active session
            let descriptor = FetchDescriptor<WorkoutSession>(
                predicate: #Predicate<WorkoutSession> { session in
                    session.programId == programId && session.endTime == nil
                },
                sortBy: [SortDescriptor(\.startTime, order: .reverse)]
            )
            
            if let activeSession = try? modelContext.fetch(descriptor).first {
                try saveSetLogWithSession(programId: programId, log: log, workoutSessionId: activeSession.id)
            }
            // If no active session found, skip saving (legacy compatibility)
        }
    }
    
    private func saveSetLogWithSession(programId: String, log: ExerciseSetLog, workoutSessionId: UUID) throws {
        guard let session = getWorkoutSession(id: workoutSessionId) else {
            throw NSError(domain: "SwiftDataProgressStore", code: 1, userInfo: [NSLocalizedDescriptionKey: "Workout session not found"])
        }
        
        // Check if log already exists in this session
        let descriptor = FetchDescriptor<SetLog>(
            predicate: #Predicate<SetLog> { setLog in
                setLog.setId == log.setId && setLog.workoutSession?.id == workoutSessionId
            }
        )
        
        if let existingLog = try? modelContext.fetch(descriptor).first {
            // Update existing log
            existingLog.completedReps = log.completedReps
            existingLog.completedWeight = log.completedWeight
            existingLog.isCompleted = log.isCompleted
            // Also update setNumber if available
            if let setNumber = log.setNumber {
                existingLog.setNumber = setNumber
            }
            if log.isCompleted && !existingLog.isCompleted {
                existingLog.completedAt = Date()
            }
        } else {
            // Create new log
            var setNumber = 1
            
            if let logSetNumber = log.setNumber {
                setNumber = logSetNumber
            } else {
                // Try to get setNumber from previous logs with same setId
                let previousLogDescriptor = FetchDescriptor<SetLog>(
                    predicate: #Predicate<SetLog> { setLog in
                        setLog.setId == log.setId && setLog.workoutSession?.programId == programId
                    },
                    sortBy: [SortDescriptor(\.completedAt, order: .reverse)]
                )
                if let previousLog = try? modelContext.fetch(previousLogDescriptor).first {
                    setNumber = previousLog.setNumber
                }
            }
            
            let setLog = SetLog(
                exerciseId: log.exerciseId,
                setId: log.setId,
                setNumber: setNumber,
                completedReps: log.completedReps,
                completedWeight: log.completedWeight,
                isCompleted: log.isCompleted,
                completedAt: log.isCompleted ? Date() : Date(),
                workoutSession: session
            )
            modelContext.insert(setLog)
        }
        
        try modelContext.save()
    }
    
    func getSetLog(programId: String, setId: String) -> ExerciseSetLog? {
        let descriptor = FetchDescriptor<SetLog>(
            predicate: #Predicate<SetLog> { setLog in
                setLog.setId == setId && setLog.workoutSession?.programId == programId
            },
            sortBy: [SortDescriptor(\.completedAt, order: .reverse)]
        )
        
        guard let setLog = try? modelContext.fetch(descriptor).first else {
            return nil
        }
        
        return ExerciseSetLog(
            exerciseId: setLog.exerciseId,
            setId: setLog.setId,
            setNumber: setLog.setNumber,
            completedReps: setLog.completedReps,
            completedWeight: setLog.completedWeight,
            isCompleted: setLog.isCompleted
        )
    }
    
    func getAllSetLogs(programId: String) -> [ExerciseSetLog] {
        let descriptor = FetchDescriptor<SetLog>(
            predicate: #Predicate<SetLog> { setLog in
                setLog.workoutSession?.programId == programId
            }
        )
        
        guard let setLogs = try? modelContext.fetch(descriptor) else {
            return []
        }
        
        return setLogs.map { setLog in
            ExerciseSetLog(
                exerciseId: setLog.exerciseId,
                setId: setLog.setId,
                setNumber: setLog.setNumber,
                completedReps: setLog.completedReps,
                completedWeight: setLog.completedWeight,
                isCompleted: setLog.isCompleted
            )
        }
    }
    
    // MARK: - New SwiftData Methods
    
    func createWorkoutSession(programId: String, workoutDayId: String) throws -> WorkoutSession {
        let session = WorkoutSession(programId: programId, workoutDayId: workoutDayId)
        modelContext.insert(session)
        try modelContext.save()
        return session
    }
    
    func getWorkoutSession(id: UUID) -> WorkoutSession? {
        let descriptor = FetchDescriptor<WorkoutSession>(
            predicate: #Predicate<WorkoutSession> { session in
                session.id == id
            }
        )
        return try? modelContext.fetch(descriptor).first
    }
    
    func getSetLogsForExercise(exerciseId: String, programId: String, from startDate: Date?, to endDate: Date?) -> [SetLog] {
        var predicate: Predicate<SetLog>
        
        if let start = startDate, let end = endDate {
            predicate = #Predicate<SetLog> { setLog in
                setLog.exerciseId == exerciseId &&
                setLog.workoutSession?.programId == programId &&
                setLog.completedAt >= start &&
                setLog.completedAt <= end
            }
        } else if let start = startDate {
            predicate = #Predicate<SetLog> { setLog in
                setLog.exerciseId == exerciseId &&
                setLog.workoutSession?.programId == programId &&
                setLog.completedAt >= start
            }
        } else if let end = endDate {
            predicate = #Predicate<SetLog> { setLog in
                setLog.exerciseId == exerciseId &&
                setLog.workoutSession?.programId == programId &&
                setLog.completedAt <= end
            }
        } else {
            predicate = #Predicate<SetLog> { setLog in
                setLog.exerciseId == exerciseId &&
                setLog.workoutSession?.programId == programId
            }
        }
        
        let descriptor = FetchDescriptor<SetLog>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.completedAt, order: .reverse)]
        )
        
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func getMostRecentSetLog(exerciseId: String, programId: String) -> SetLog? {
        let descriptor = FetchDescriptor<SetLog>(
            predicate: #Predicate<SetLog> { setLog in
                setLog.exerciseId == exerciseId &&
                setLog.workoutSession?.programId == programId &&
                setLog.isCompleted == true
            },
            sortBy: [SortDescriptor(\.completedAt, order: .reverse)]
        )
        
        return try? modelContext.fetch(descriptor).first
    }
    
    func getActiveWorkoutSession(programId: String, workoutDayId: String) -> WorkoutSession? {
        let descriptor = FetchDescriptor<WorkoutSession>(
            predicate: #Predicate<WorkoutSession> { session in
                session.programId == programId &&
                session.workoutDayId == workoutDayId &&
                session.endTime == nil
            },
            sortBy: [SortDescriptor(\.startTime, order: .reverse)]
        )
        
        return try? modelContext.fetch(descriptor).first
    }
    
    func finishWorkout(programId: String, workoutSessionId: UUID) throws {
        guard let session = getWorkoutSession(id: workoutSessionId) else {
            throw NSError(domain: "SwiftDataProgressStore", code: 1, userInfo: [NSLocalizedDescriptionKey: "Workout session not found"])
        }
        
        session.endTime = Date()
        try modelContext.save()
    }
    
    // MARK: - History Methods
    
    func getAllWorkoutSessions() -> [WorkoutSession] {
        let descriptor = FetchDescriptor<WorkoutSession>(
            predicate: #Predicate<WorkoutSession> { session in
                session.endTime != nil
            },
            sortBy: [SortDescriptor(\.startTime, order: .reverse)]
        )
        
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func getWorkoutSessions(programId: String, workoutDayId: String) -> [WorkoutSession] {
        let descriptor = FetchDescriptor<WorkoutSession>(
            predicate: #Predicate<WorkoutSession> { session in
                session.programId == programId &&
                session.workoutDayId == workoutDayId &&
                session.endTime != nil
            },
            sortBy: [SortDescriptor(\.startTime, order: .reverse)]
        )
        
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func getAllSetLogsForExercise(exerciseId: String) -> [SetLog] {
        let descriptor = FetchDescriptor<SetLog>(
            predicate: #Predicate<SetLog> { setLog in
                setLog.exerciseId == exerciseId &&
                setLog.workoutSession?.endTime != nil
            },
            sortBy: [SortDescriptor(\.completedAt, order: .reverse)]
        )
        
        return (try? modelContext.fetch(descriptor)) ?? []
    }
}
