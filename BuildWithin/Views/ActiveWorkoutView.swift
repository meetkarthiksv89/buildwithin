//
//  ActiveWorkoutView.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import SwiftUI
import UIKit

struct ActiveWorkoutView: View {
    let exercises: [Exercise]
    let programId: String
    let workoutDayId: String
    let programName: String
    let workoutDayName: String
    let allPrograms: [ProgramContent]
    let progressStore: ProgressStoreProtocol
    
    @StateObject private var viewModel: ActiveWorkoutViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var navigationState: NavigationState
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var showingFinishAlert = false
    @State private var showCompletionView = false
    @State private var showingCloseAlert = false
    @State private var isKeyboardVisible = false
    @State private var showVideo = false
    @State private var videoURL: String?
    
    init(exercises: [Exercise], programId: String, workoutDayId: String, programName: String, workoutDayName: String, allPrograms: [ProgramContent], progressStore: ProgressStoreProtocol) {
        self.exercises = exercises
        self.programId = programId
        self.workoutDayId = workoutDayId
        self.programName = programName
        self.workoutDayName = workoutDayName
        self.allPrograms = allPrograms
        self.progressStore = progressStore
        _viewModel = StateObject(wrappedValue: ActiveWorkoutViewModel(
            exercises: exercises,
            programId: programId,
            workoutDayId: workoutDayId,
            progressStore: progressStore
        ))
    }
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            if let currentExercise = viewModel.currentExercise {
                VStack(spacing: 0) {
                    // Top bar
                    HStack {
                        Button(action: { 
                            showingCloseAlert = true
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.appTextPrimary)
                                .font(.system(size: 16))
                                .frame(width: 32, height: 32)
                                .background(Color.appCardBackground)
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                        
                        Text("Exercise \(viewModel.currentExerciseIndex + 1) of \(exercises.count)")
                            .font(.headline)
                            .foregroundColor(.appTextPrimary)
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.appPrimaryGreen)
                                .font(.system(size: 14))
                            Text(timeString(from: elapsedTime))
                                .font(.headline)
                                .foregroundColor(.appTextPrimary)
                        }
                    }
                    .padding()
                    
                    // Progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.appCardBackground)
                                .frame(height: 4)
                            
                            Rectangle()
                                .fill(Color.appPrimaryGreen)
                                .frame(width: geometry.size.width * progress, height: 4)
                        }
                    }
                    .frame(height: 4)
                    .padding(.horizontal)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            
                            // Exercise name
                            HStack {
                                Text(currentExercise.name)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.appTextPrimary)
                                
                                Spacer()
                                
                                if let videoLink = currentExercise.videoLink, let url = URL(string: videoLink) {
                                    Button(action: {
                                        videoURL = videoLink
                                        showVideo = true
                                    }) {
                                        Circle()
                                            .fill(Color.appTextSecondary.opacity(0.2))
                                            .frame(width: 35, height: 35)
                                            .overlay {
                                                Image(systemName: "play.fill")
                                                    .foregroundColor(.appTextSecondary)
                                                    .font(.system(size: 16))
                                            }
                                    }
                                }
                            }
                            .padding()
                            
                            // Sets section
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Sets")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.appTextPrimary)
                                    .padding(.horizontal)
                                
                                ForEach(currentExercise.sets) { set in
                                    SetCompletionRow(
                                        set: set,
                                        exercise: currentExercise,
                                        viewModel: viewModel
                                    )
                                    .padding(.horizontal)
                                }
                                
                                // Add Set Button - Centered icon only
                                Button(action: {
                                    viewModel.addSetToCurrentExercise()
                                }) {
                                    Image(systemName: "plus")
                                        .foregroundColor(.appPrimaryGreen)
                                        .font(.system(size: 24, weight: .medium))
                                        .frame(width: 44, height: 44)
                                        .background(Color.appCardBackground)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(Color.appPrimaryGreen.opacity(0.3), lineWidth: 1.5)
                                        )
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                            }
                        }
                        .padding(.vertical)
                    }
                    .scrollDismissesKeyboard(.interactively)
                    
                    // Bottom navigation
                    if !isKeyboardVisible {
                        VStack(spacing: 0) {
                            // Divider
                            Rectangle()
                                .fill(Color.appInactiveGray.opacity(0.3))
                                .frame(height: 0.5)
                            
                            HStack(spacing: 16) {
                                // Previous button
                                Button(action: {
                                    viewModel.previousExercise()
                                }) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(viewModel.canGoToPrevious ? .appTextPrimary : .appTextSecondary)
                                        .frame(width: 56, height: 56)
                                        .background(Color.appCardBackground)
                                        .cornerRadius(12)
                                }
                                .disabled(!viewModel.canGoToPrevious)
                                
                                // Sneak peek for next exercise (if not last)
                                if let nextExercise = nextExercise, !viewModel.isLastExercise {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Next")
                                            .font(.system(size: 11, weight: .medium))
                                            .foregroundColor(.appTextSecondary)
                                        
                                        Text(nextExercise.name)
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.appTextPrimary)
                                            .lineLimit(1)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 4)
                                }
                                
                                // Next/Finish button
                                if viewModel.isLastExercise {
                                    Button(action: {
                                        showingFinishAlert = true
                                    }) {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 56)
                                            .background(Color.appPrimaryGreen)
                                            .cornerRadius(12)
                                    }
                                } else {
                                    Button(action: {
                                        viewModel.nextExercise()
                                    }) {
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundColor(.black)
                                            .frame(width: 56, height: 56)
                                            .background(Color.appPrimaryGreen)
                                            .cornerRadius(12)
                                    }
                                }
                            }
                            .padding(16)
                            .background(Color.appBackground)
                        }
                    }
                }
            }
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            isKeyboardVisible = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            isKeyboardVisible = false
        }
        .alert("Finish Workout?", isPresented: $showingFinishAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Finish") {
                finishWorkout()
            }
        } message: {
            Text("Are you sure you want to finish this workout?")
        }
        .alert("End Workout Session?", isPresented: $showingCloseAlert) {
            Button("Cancel", role: .cancel) {}
            Button("End Session", role: .destructive) {
                stopTimer()
                dismiss()
            }
        } message: {
            Text("Are you sure you want to end this workout session? Your progress will not be saved.")
        }
        .sheet(isPresented: $showCompletionView) {
            WorkoutCompletionView(
                duration: elapsedTime,
                exerciseCount: exercises.count,
                workoutSessionId: viewModel.sessionId,
                programId: programId,
                workoutDayId: workoutDayId,
                programName: programName,
                workoutDayName: workoutDayName,
                allPrograms: allPrograms,
                progressStore: progressStore,
                onDismiss: {
                    showCompletionView = false
                    navigationState.popToRoot()
                }
            )
            .presentationDetents([.large])
            .interactiveDismissDisabled(false)
        }
        .sheet(isPresented: $showVideo) {
            if let videoURLString = videoURL, let url = URL(string: videoURLString) {
                SafariView(url: url)
            }
        }
    }
    
    private var progress: Double {
        guard exercises.count > 0 else { return 0 }
        return Double(viewModel.currentExerciseIndex + 1) / Double(exercises.count)
    }
    
    private var nextExercise: Exercise? {
        guard viewModel.canGoToNext else { return nil }
        return exercises[viewModel.currentExerciseIndex + 1]
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            elapsedTime += 1
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func finishWorkout() {
        do {
            try viewModel.finishWorkout()
            stopTimer()
            showCompletionView = true
        } catch {
            print("Error finishing workout: \(error)")
        }
    }
}

#Preview {
    NavigationStack {
        ActiveWorkoutView(
            exercises: [
                Exercise(
                    id: "ex1",
                    workoutDayId: "day1",
                    name: "Barbell Bench Press",
                    order: 1,
                    equipment: .barbell,
                    restSeconds: 90,
                    targetMuscleGroups: [.chest, .arms],
                    sets: [
                        ExerciseSet(id: "s1", setNumber: 1, targetReps: 10, targetWeight: nil),
                        ExerciseSet(id: "s2", setNumber: 2, targetReps: 10, targetWeight: nil),
                        ExerciseSet(id: "s3", setNumber: 3, targetReps: 10, targetWeight: nil)
                    ],
                    videoLink: "https://www.youtube.com/watch?v=k9MY1ijAvGo"
                ),
                Exercise(
                    id: "ex1",
                    workoutDayId: "day1",
                    name: "Barbell Bench Press",
                    order: 1,
                    equipment: .barbell,
                    restSeconds: 90,
                    targetMuscleGroups: [.chest, .arms],
                    sets: [
                        ExerciseSet(id: "s1", setNumber: 1, targetReps: 10, targetWeight: nil),
                        ExerciseSet(id: "s2", setNumber: 2, targetReps: 10, targetWeight: nil),
                        ExerciseSet(id: "s3", setNumber: 3, targetReps: 10, targetWeight: nil)
                    ],
                    videoLink: "https://www.youtube.com/watch?v=k9MY1ijAvGo"
                )
            ],
            programId: "prog1",
            workoutDayId: "day1",
            programName: "Test Program",
            workoutDayName: "Day 1",
            allPrograms: [],
            progressStore: ProgressStore()
        )
        .environmentObject(NavigationState())
    }
}
