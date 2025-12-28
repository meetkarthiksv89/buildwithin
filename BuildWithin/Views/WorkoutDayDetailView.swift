//
//  WorkoutDayDetailView.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import SwiftUI

struct WorkoutDayDetailView: View {
    let workoutDay: WorkoutDay
    let program: Program
    let repository: ProgramRepository
    let progressStore: ProgressStoreProtocol
    let allPrograms: [ProgramContent]
    
    @StateObject private var viewModel: WorkoutDayDetailViewModel
    
    init(workoutDay: WorkoutDay, program: Program, repository: ProgramRepository, progressStore: ProgressStoreProtocol, allPrograms: [ProgramContent]) {
        self.workoutDay = workoutDay
        self.program = program
        self.repository = repository
        self.progressStore = progressStore
        self.allPrograms = allPrograms
        _viewModel = StateObject(wrappedValue: WorkoutDayDetailViewModel(
            workoutDay: workoutDay,
            repository: repository,
            progressStore: progressStore,
            allPrograms: allPrograms
        ))
    }
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header section
                        VStack(alignment: .leading, spacing: 12) {
                            Text(workoutDay.title)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.appTextPrimary)
                            
                            if let description = workoutDay.description {
                                Text(description)
                                    .font(.body)
                                    .foregroundColor(.appTextSecondary)
                            }
                            
                            // Duration and difficulty
                            HStack(spacing: 16) {
                                HStack(spacing: 4) {
                                    Image(systemName: "clock.fill")
                                        .foregroundColor(.appPrimaryGreen)
                                        .font(.system(size: 14))
                                    Text("\(workoutDay.estimatedDurationMinutes) mins")
                                        .foregroundColor(.appTextPrimary)
                                }
                                
                                Rectangle()
                                    .fill(Color.appTextSecondary.opacity(0.3))
                                    .frame(width: 1, height: 16)
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "chart.bar.fill")
                                        .foregroundColor(.appPrimaryGreen)
                                        .font(.system(size: 14))
                                    Text("Intermediate")
                                        .foregroundColor(.appTextPrimary)
                                }
                            }
                            .font(.subheadline)
                        }
                        .padding()
                        
                        Divider()
                            .background(Color.appTextSecondary.opacity(0.3))
                            .padding(.horizontal)
                        
                        // Routine section
                        HStack {
                            Text("ROUTINE")
                                .font(.caption)
                                .foregroundColor(.appTextSecondary)
                            
                            Spacer()
                            
                            Text("\(viewModel.exercises.count) Exercises")
                                .font(.caption)
                                .foregroundColor(.appTextSecondary)
                        }
                        .padding(.horizontal)
                        
                        // Exercise list
                        ForEach(viewModel.exercises) { exercise in
                            ExerciseRow(exercise: exercise)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
                
                // Start Workout button
                NavigationLink(destination: ActiveWorkoutView(
                    exercises: viewModel.exercises,
                    programId: program.id,
                    workoutDayId: workoutDay.id,
                    progressStore: progressStore
                )) {
                    HStack {
                        Image(systemName: "play.fill")
                            .foregroundColor(.black)
                            .font(.system(size: 16))
                        Text("Start Workout")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.appPrimaryGreen)
                    .cornerRadius(12)
                }
                .padding()
            }
        }
        .navigationTitle("DAY \(String(format: "%02d", workoutDay.dayNumber))")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        WorkoutDayDetailView(
            workoutDay: WorkoutDay(
                id: "day1",
                programId: "prog1",
                dayNumber: 14,
                title: "Upper Body Power",
                description: "Focus on building strength in the chest, shoulders, and triceps with compound movements. Keep rest times strictly under 90 seconds.",
                estimatedDurationMinutes: 45,
                isRestDay: false
            ),
            program: Program(
                id: "prog1",
                title: "Test Program",
                subtitle: "Test",
                category: .strength,
                coverImageURL: "",
                totalDays: 4,
                isActive: true
            ),
            repository: ProgramRepository(),
            progressStore: ProgressStore(),
            allPrograms: []
        )
    }
}
