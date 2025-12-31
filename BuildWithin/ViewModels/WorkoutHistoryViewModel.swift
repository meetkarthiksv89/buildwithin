//
//  WorkoutHistoryViewModel.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import Foundation
import Combine

struct GroupedSession {
    let title: String
    let sessions: [WorkoutSession]
}

@MainActor
class WorkoutHistoryViewModel: ObservableObject {
    @Published var workoutSessions: [WorkoutSession] = []
    @Published var groupedSessions: [GroupedSession] = []
    @Published var isLoading: Bool = false
    
    private let progressStore: ProgressStoreProtocol
    private let allPrograms: [ProgramContent]
    
    init(progressStore: ProgressStoreProtocol, allPrograms: [ProgramContent]) {
        self.progressStore = progressStore
        self.allPrograms = allPrograms
        loadWorkoutSessions()
    }
    
    func loadWorkoutSessions() {
        isLoading = true
        workoutSessions = progressStore.getAllWorkoutSessions()
        groupSessionsByDate()
        isLoading = false
    }
    
    private func groupSessionsByDate() {
        let calendar = Calendar.current
        let now = Date()
        
        var todaySessions: [WorkoutSession] = []
        var yesterdaySessions: [WorkoutSession] = []
        var thisWeekSessions: [WorkoutSession] = []
        var thisMonthSessions: [WorkoutSession] = []
        var olderSessions: [WorkoutSession] = []
        
        for session in workoutSessions {
            let startTime = session.startTime
            
            if calendar.isDateInToday(startTime) {
                todaySessions.append(session)
            } else if calendar.isDateInYesterday(startTime) {
                yesterdaySessions.append(session)
            } else if calendar.dateInterval(of: .weekOfYear, for: now)?.contains(startTime) == true {
                thisWeekSessions.append(session)
            } else if calendar.dateInterval(of: .month, for: now)?.contains(startTime) == true {
                thisMonthSessions.append(session)
            } else {
                olderSessions.append(session)
            }
        }
        
        var groups: [GroupedSession] = []
        
        if !todaySessions.isEmpty {
            groups.append(GroupedSession(title: "Today", sessions: todaySessions))
        }
        if !yesterdaySessions.isEmpty {
            groups.append(GroupedSession(title: "Yesterday", sessions: yesterdaySessions))
        }
        if !thisWeekSessions.isEmpty {
            groups.append(GroupedSession(title: "This Week", sessions: thisWeekSessions))
        }
        if !thisMonthSessions.isEmpty {
            groups.append(GroupedSession(title: "This Month", sessions: thisMonthSessions))
        }
        if !olderSessions.isEmpty {
            groups.append(GroupedSession(title: "Older", sessions: olderSessions))
        }
        
        groupedSessions = groups
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
    
    func getDuration(for session: WorkoutSession) -> TimeInterval? {
        guard let endTime = session.endTime else {
            return nil
        }
        return endTime.timeIntervalSince(session.startTime)
    }
    
    func getUniqueExerciseCount(for session: WorkoutSession) -> Int {
        let exerciseIds = Set(session.setLogs.map { $0.exerciseId })
        return exerciseIds.count
    }
}
