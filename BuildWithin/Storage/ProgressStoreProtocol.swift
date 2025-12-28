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
    
    func saveSetLog(programId: String, log: ExerciseSetLog) throws
    func getSetLog(programId: String, setId: String) -> ExerciseSetLog?
    func getAllSetLogs(programId: String) -> [ExerciseSetLog]
}
