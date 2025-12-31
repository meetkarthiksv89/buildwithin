//
//  ProgramDaysViewModel.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import Foundation
import Combine

@MainActor
class ProgramDaysViewModel: ObservableObject {
    @Published var days: [WorkoutDay] = []
    @Published var weeks: [Week] = []
    @Published var program: Program
    
    private let repository: ProgramRepository
    private let progressStore: ProgressStoreProtocol
    private var allPrograms: [ProgramContent] = []
    
    init(program: Program, repository: ProgramRepository, progressStore: ProgressStoreProtocol, allPrograms: [ProgramContent]) {
        self.program = program
        self.repository = repository
        self.progressStore = progressStore
        self.allPrograms = allPrograms
        loadDays()
    }
    
    private func loadDays() {
        days = repository.days(for: program.id, in: allPrograms)
    }
    
    func isDayCompleted(_ workoutDay: WorkoutDay) -> Bool {
        return progressStore.getWorkoutDayCompletion(programId: program.id, workoutDayId: workoutDay.id) != nil
    }
    
    func getCompletionDate(for workoutDay: WorkoutDay) -> Date? {
        return progressStore.getWorkoutDayCompletion(programId: program.id, workoutDayId: workoutDay.id)?.completedAt
    }
}
