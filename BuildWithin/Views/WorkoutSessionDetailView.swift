//
//  WorkoutSessionDetailView.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import SwiftUI

struct WorkoutSessionDetailView: View {
    let session: WorkoutSession
    let programName: String
    let workoutDayName: String
    let allPrograms: [ProgramContent]
    
    @State private var exerciseGroups: [(exercise: Exercise, sets: [SetLog])] = []
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header section
                    VStack(alignment: .leading, spacing: 12) {
                        Text(formatDate(session.startTime))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.appTextPrimary)
                        
                        if let endTime = session.endTime {
                            HStack(spacing: 8) {
                                Text(formatTime(session.startTime))
                                    .foregroundColor(.appTextSecondary)
                                Text("-")
                                    .foregroundColor(.appTextSecondary)
                                Text(formatTime(endTime))
                                    .foregroundColor(.appTextSecondary)
                            }
                            .font(.body)
                            
                            if let duration = getDuration() {
                                HStack(spacing: 4) {
                                    Image(systemName: "clock.fill")
                                        .foregroundColor(.appPrimaryGreen)
                                        .font(.system(size: 14))
                                    Text("Duration: \(formatDuration(duration))")
                                        .foregroundColor(.appTextPrimary)
                                }
                                .font(.subheadline)
                            }
                        }
                        
                        Text("\(programName) • \(workoutDayName)")
                            .font(.subheadline)
                            .foregroundColor(.appLightGreen)
                    }
                    .padding()
                    
                    Divider()
                        .background(Color.appTextSecondary.opacity(0.3))
                        .padding(.horizontal)
                    
                    // Exercises section
                    if !exerciseGroups.isEmpty {
                        HStack {
                            Text("EXERCISES")
                                .font(.caption)
                                .foregroundColor(.appTextSecondary)
                            
                            Spacer()
                            
                            Text("\(exerciseGroups.count) exercise\(exerciseGroups.count == 1 ? "" : "s")")
                                .font(.caption)
                                .foregroundColor(.appTextSecondary)
                        }
                        .padding(.horizontal)
                        
                        ForEach(Array(exerciseGroups.enumerated()), id: \.element.exercise.id) { index, group in
                            ExerciseSessionCard(exercise: group.exercise, sets: group.sets)
                                .padding(.horizontal)
                        }
                    } else {
                        Text("No exercises completed")
                            .foregroundColor(.appTextSecondary)
                            .padding()
                    }
                }
                .padding(.vertical)
            }
        }
        .navigationTitle("Workout History")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadExerciseGroups()
        }
    }
    
    private func loadExerciseGroups() {
        // Group set logs by exerciseId
        var exerciseMap: [String: [SetLog]] = [:]
        
        for setLog in session.setLogs {
            if exerciseMap[setLog.exerciseId] == nil {
                exerciseMap[setLog.exerciseId] = []
            }
            exerciseMap[setLog.exerciseId]?.append(setLog)
        }
        
        // Get exercise details from allPrograms
        var groups: [(exercise: Exercise, sets: [SetLog])] = []
        
        for (exerciseId, sets) in exerciseMap {
            // Find exercise in programs
            for program in allPrograms {
                if let exercise = program.exercises.first(where: { $0.id == exerciseId }) {
                    // Sort sets by setNumber
                    let sortedSets = sets.sorted { $0.setNumber < $1.setNumber }
                    groups.append((exercise: exercise, sets: sortedSets))
                    break
                }
            }
        }
        
        // Sort by exercise order
        groups.sort { $0.exercise.order < $1.exercise.order }
        
        exerciseGroups = groups
    }
    
    private func getDuration() -> TimeInterval? {
        guard let endTime = session.endTime else {
            return nil
        }
        return endTime.timeIntervalSince(session.startTime)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        
        if minutes > 0 {
            return "\(minutes) minute\(minutes == 1 ? "" : "s")"
        } else {
            return "\(seconds) second\(seconds == 1 ? "" : "s")"
        }
    }
}

struct ExerciseSessionCard: View {
    let exercise: Exercise
    let sets: [SetLog]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Exercise name
            Text(exercise.name)
                .font(.headline)
                .foregroundColor(.appTextPrimary)
            
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
        WorkoutSessionDetailView(
            session: WorkoutSession(
                programId: "prog1",
                workoutDayId: "day1",
                startTime: Date(),
                endTime: Date().addingTimeInterval(2520)
            ),
            programName: "Fat Loss 4 Day",
            workoutDayName: "Upper Body Power",
            allPrograms: []
        )
    }
}
