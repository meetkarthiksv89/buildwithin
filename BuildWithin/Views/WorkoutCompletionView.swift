//
//  WorkoutCompletionView.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import SwiftUI

struct WorkoutCompletionView: View {
    let duration: TimeInterval
    let exerciseCount: Int
    let workoutSessionId: UUID?
    let programId: String
    let workoutDayId: String
    let programName: String
    let workoutDayName: String
    let allPrograms: [ProgramContent]
    let progressStore: ProgressStoreProtocol
    let onDismiss: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var workoutSession: WorkoutSession?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Close button at top right
                    HStack {
                        Spacer()
                        Button(action: {
                            onDismiss()
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.appTextPrimary)
                                .font(.system(size: 16))
                                .frame(width: 32, height: 32)
                                .background(Color.appCardBackground)
                                .clipShape(Circle())
                        }
                        .padding()
                    }
                    
                    ScrollView {
                        VStack(spacing: 32) {
                            // Trophy icon with decorative dots
                            ZStack {
                        // Decorative dots
                        Circle()
                            .fill(Color.yellow)
                            .frame(width: 8, height: 8)
                            .offset(x: 40, y: -30)
                        
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 8, height: 8)
                            .offset(x: -50, y: -10)
                        
                        Circle()
                            .fill(Color.purple)
                            .frame(width: 6, height: 6)
                            .offset(x: -40, y: 50)
                        
                        Circle()
                            .fill(Color.purple)
                            .frame(width: 6, height: 6)
                            .offset(x: 40, y: 50)
                        
                        // Trophy circle background
                        Circle()
                            .fill(Color.appLightGreen.opacity(0.2))
                            .frame(width: 120, height: 120)
                        
                            // Trophy icon
                            Image(systemName: "trophy.fill")
                                .font(.system(size: 48))
                                .foregroundColor(.appPrimaryGreen)
                            }
                            .padding(.top, 40)
                            
                            // Header text
                            VStack(spacing: 8) {
                        HStack(spacing: 8) {
                            Text("Workout Complete!")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.appTextPrimary)
                            
                            Text("🎉")
                                .font(.system(size: 28))
                        }
                        
                            Text("Great job crushing your goals today.")
                                .font(.subheadline)
                                .foregroundColor(.appTextSecondary)
                            }
                            
                            // Stats cards
                            VStack(spacing: 16) {
                            // Duration and Exercises row
                            HStack(spacing: 16) {
                                StatCard(
                                    icon: "stopwatch",
                                    value: formatDuration(duration),
                                    label: "DURATION"
                                )
                                
                                StatCard(
                                    icon: "dumbbell",
                                    value: "\(exerciseCount)",
                                    label: "EXERCISES"
                                )
                            }
                            
                            // Calories card (full width)
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(estimatedCalories)")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(.appTextPrimary)
                                    
                                    Text("CALORIES")
                                        .font(.caption)
                                        .foregroundColor(.appTextSecondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.orange)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.appCardBackground)
                            .cornerRadius(16)
                            }
                            .padding(.horizontal)
                            
                            // Action button
                            VStack(spacing: 12) {
                                // View Workout Details button
                                NavigationLink(destination: workoutDetailsView) {
                                    Text("View Workout Details")
                                        .font(.headline)
                                        .foregroundColor(.appTextPrimary)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.appCardBackground)
                                        .cornerRadius(12)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 40)
                        }
                    }
                }
            }
        }
        .onAppear {
            loadWorkoutSession()
        }
    }
    
    @ViewBuilder
    private var workoutDetailsView: some View {
        if let session = workoutSession {
            WorkoutSessionDetailView(
                session: session,
                programName: programName,
                workoutDayName: workoutDayName,
                allPrograms: allPrograms,
                progressStore: progressStore
            )
        } else {
            // Fallback view if session not found
            Text("Workout session not found")
                .foregroundColor(.appTextSecondary)
        }
    }
    
    private var estimatedCalories: Int {
        let durationInMinutes = duration / 60
        // Simple estimation: ~7 calories per minute + 10 per exercise
        return Int((durationInMinutes * 7) + (Double(exerciseCount) * 10))
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private func loadWorkoutSession() {
        guard let sessionId = workoutSessionId else { return }
        workoutSession = progressStore.getWorkoutSession(id: sessionId)
    }
}

struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.appTextSecondary)
            
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.appTextPrimary)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.appTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.appCardBackground)
        .cornerRadius(16)
    }
}

#Preview {
    WorkoutCompletionView(
        duration: 2720, // 45:20
        exerciseCount: 8,
        workoutSessionId: UUID(),
        programId: "prog1",
        workoutDayId: "day1",
        programName: "Fat Loss 4 Day",
        workoutDayName: "Upper Body Power",
        allPrograms: [],
        progressStore: ProgressStore(),
        onDismiss: {}
    )
}
