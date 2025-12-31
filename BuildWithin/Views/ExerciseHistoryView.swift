//
//  ExerciseHistoryView.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/28/25.
//

import SwiftUI

struct ExerciseHistoryView: View {
    let exercise: Exercise
    let progressStore: ProgressStoreProtocol
    let allPrograms: [ProgramContent]
    
    @StateObject private var viewModel: ExerciseHistoryViewModel
    
    init(exercise: Exercise, progressStore: ProgressStoreProtocol, allPrograms: [ProgramContent]) {
        self.exercise = exercise
        self.progressStore = progressStore
        self.allPrograms = allPrograms
        _viewModel = StateObject(wrappedValue: ExerciseHistoryViewModel(
            exercise: exercise,
            progressStore: progressStore,
            allPrograms: allPrograms
        ))
    }
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            if viewModel.isLoading {
                VStack(spacing: 16) {
                    ProgressView()
                        .tint(.appPrimaryGreen)
                    Text("Loading history...")
                        .foregroundColor(.appTextSecondary)
                }
            } else if viewModel.sessionGroups.isEmpty {
                // Empty state
                VStack(spacing: 16) {
                    Image(systemName: "clock.badge.xmark")
                        .font(.system(size: 64))
                        .foregroundColor(.appTextSecondary)
                    Text("No History")
                        .font(.headline)
                        .foregroundColor(.appTextPrimary)
                    Text("Complete workouts with this exercise to see your history here")
                        .font(.subheadline)
                        .foregroundColor(.appTextSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Exercise name header
                        VStack(alignment: .leading, spacing: 8) {
                            Text(exercise.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.appTextPrimary)
                            
                            Text("\(viewModel.sessionGroups.count) workout\(viewModel.sessionGroups.count == 1 ? "" : "s")")
                                .font(.subheadline)
                                .foregroundColor(.appTextSecondary)
                        }
                        .padding()
                        
                        Divider()
                            .background(Color.appTextSecondary.opacity(0.3))
                            .padding(.horizontal)
                        
                        // Sessions list
                        ForEach(viewModel.sessionGroups, id: \.session.id) { group in
                            ExerciseHistorySessionCard(
                                session: group.session,
                                sets: group.sets,
                                exercise: exercise,
                                programName: viewModel.getProgramName(for: group.session),
                                workoutDayName: viewModel.getWorkoutDayName(for: group.session),
                                formatDate: viewModel.formatDate,
                                formatTime: viewModel.formatTime
                            )
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .navigationTitle("Exercise History")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ExerciseHistorySessionCard: View {
    let session: WorkoutSession
    let sets: [SetLog]
    let exercise: Exercise
    let programName: String
    let workoutDayName: String
    let formatDate: (Date) -> String
    let formatTime: (Date) -> String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Session header
            VStack(alignment: .leading, spacing: 8) {
                Text(formatDate(session.startTime))
                    .font(.headline)
                    .foregroundColor(.appTextPrimary)
                
                HStack(spacing: 8) {
                    Text(formatTime(session.startTime))
                        .foregroundColor(.appTextSecondary)
                    
                    if let endTime = session.endTime {
                        Text("-")
                            .foregroundColor(.appTextSecondary)
                        Text(formatTime(endTime))
                            .foregroundColor(.appTextSecondary)
                    }
                }
                .font(.subheadline)
                
                Text("\(programName) • \(workoutDayName)")
                    .font(.caption)
                    .foregroundColor(.appLightGreen)
            }
            
            Divider()
                .background(Color.appTextSecondary.opacity(0.3))
            
            // Sets table
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    Text("SET")
                        .font(.caption)
                        .foregroundColor(.appTextSecondary)
                        .frame(width: 40)
                    
                    Text("LBS")
                        .font(.caption)
                        .foregroundColor(.appTextSecondary)
                        .frame(width: 80)
                    
                    Text("REPS")
                        .font(.caption)
                        .foregroundColor(.appTextSecondary)
                        .frame(width: 80)
                    
                    Spacer()
                }
                
                // Sets
                ForEach(sets, id: \.id) { setLog in
                    HStack {
                        Text("\(setLog.setNumber)")
                            .font(.headline)
                            .foregroundColor(.appTextSecondary)
                            .frame(width: 40)
                        
                        if exercise.equipment != .bodyweight {
                            Text(setLog.completedWeight != nil ? String(format: "%.0f", setLog.completedWeight!) : "-")
                                .font(.body)
                                .foregroundColor(.appTextPrimary)
                                .frame(width: 80)
                        } else {
                            Text("BW")
                                .font(.body)
                                .foregroundColor(.appTextSecondary)
                                .frame(width: 80)
                        }
                        
                        Text(setLog.completedReps != nil ? "\(setLog.completedReps!)" : "-")
                            .font(.body)
                            .foregroundColor(.appTextPrimary)
                            .frame(width: 80)
                        
                        Spacer()
                        
                        if setLog.isCompleted {
                            Image(systemName: "checkmark")
                                .foregroundColor(.appPrimaryGreen)
                                .font(.system(size: 14, weight: .bold))
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .background(Color.appCardBackground)
        .cornerRadius(16)
    }
}

#Preview {
    NavigationStack {
        ExerciseHistoryView(
            exercise: Exercise(
                id: "ex1",
                workoutDayId: "day1",
                name: "Bench Press",
                order: 1,
                equipment: .barbell,
                restSeconds: 90,
                targetMuscleGroups: [.chest],
                sets: [],
                videoLink: nil
            ),
            progressStore: ProgressStore(),
            allPrograms: []
        )
    }
}
