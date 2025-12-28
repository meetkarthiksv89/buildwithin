//
//  WorkoutDayDetailViewModel.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import Foundation
import Combine

@MainActor
class WorkoutDayDetailViewModel: ObservableObject {
    @Published var exercises: [Exercise] = []
    @Published var workoutDay: WorkoutDay
    
    private let repository: ProgramRepository
    private let progressStore: ProgressStoreProtocol
    private var allPrograms: [ProgramContent] = []
    
    init(workoutDay: WorkoutDay, repository: ProgramRepository, progressStore: ProgressStoreProtocol, allPrograms: [ProgramContent]) {
        self.workoutDay = workoutDay
        self.repository = repository
        self.progressStore = progressStore
        self.allPrograms = allPrograms
        loadExercises()
    }
    
    private func loadExercises() {
        exercises = repository.exercises(for: workoutDay.id, in: allPrograms)
    }
    
    func getExerciseSummary(for exercise: Exercise) -> String {
        let setsCount = exercise.sets.count
        if let firstSet = exercise.sets.first, let reps = firstSet.targetReps {
            return "\(setsCount) sets x \(reps) reps"
        } else if let firstSet = exercise.sets.first, firstSet.targetReps == nil {
            return "\(setsCount) sets"
        }
        return "\(setsCount) sets"
    }
}
