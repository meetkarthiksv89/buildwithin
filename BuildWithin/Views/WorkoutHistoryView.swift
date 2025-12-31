//
//  WorkoutHistoryView.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import SwiftUI

struct WorkoutHistoryView: View {
    let progressStore: ProgressStoreProtocol
    let allPrograms: [ProgramContent]
    
    @StateObject private var viewModel: WorkoutHistoryViewModel
    
    init(progressStore: ProgressStoreProtocol, allPrograms: [ProgramContent]) {
        self.progressStore = progressStore
        self.allPrograms = allPrograms
        _viewModel = StateObject(wrappedValue: WorkoutHistoryViewModel(
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
            } else if viewModel.groupedSessions.isEmpty {
                // Empty state
                VStack(spacing: 16) {
                    Image(systemName: "clock.badge.xmark")
                        .font(.system(size: 64))
                        .foregroundColor(.appTextSecondary)
                    Text("No Workout History")
                        .font(.headline)
                        .foregroundColor(.appTextPrimary)
                    Text("Complete a workout to see your history here")
                        .font(.subheadline)
                        .foregroundColor(.appTextSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        ForEach(viewModel.groupedSessions, id: \.title) { group in
                            VStack(alignment: .leading, spacing: 16) {
                                // Section header
                                Text(group.title)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.appLightGreen)
                                    .padding(.horizontal)
                                
                                // Sessions in this group
                                ForEach(group.sessions, id: \.id) { session in
                                    NavigationLink(destination: WorkoutSessionDetailView(
                                        session: session,
                                        programName: viewModel.getProgramName(for: session),
                                        workoutDayName: viewModel.getWorkoutDayName(for: session),
                                        allPrograms: allPrograms,
                                        progressStore: progressStore
                                    )) {
                                        WorkoutSessionRow(
                                            session: session,
                                            programName: viewModel.getProgramName(for: session),
                                            workoutDayName: viewModel.getWorkoutDayName(for: session),
                                            duration: viewModel.getDuration(for: session),
                                            exerciseCount: viewModel.getUniqueExerciseCount(for: session)
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .navigationTitle("Workout History")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        WorkoutHistoryView(
            progressStore: ProgressStore(),
            allPrograms: []
        )
    }
}
