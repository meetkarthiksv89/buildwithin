//
//  ActiveWorkoutView.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import SwiftUI

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
                        Button(action: { dismiss() }) {
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
                            // Video placeholder
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.appCardBackground)
                                .frame(height: 250)
                                .overlay {
                                    VStack {
                                        Image(systemName: "play.circle.fill")
                                            .font(.system(size: 64))
                                            .foregroundColor(.appTextSecondary)
                                        Text("Exercise Video")
                                            .font(.subheadline)
                                            .foregroundColor(.appTextSecondary)
                                    }
                                }
                                .padding()
                            
                            // Exercise name
                            HStack {
                                Text(currentExercise.name)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.appTextPrimary)
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    Circle()
                                        .fill(Color.appPrimaryGreen)
                                        .frame(width: 44, height: 44)
                                        .overlay {
                                            Image(systemName: "mic.fill")
                                                .foregroundColor(.black)
                                                .font(.system(size: 16))
                                        }
                                }
                            }
                            .padding(.horizontal)
                            
                            // Sets section
                            VStack(alignment: .leading, spacing: 16) {
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
                                .padding(.horizontal)
                                
                                ForEach(currentExercise.sets) { set in
                                    SetCompletionRow(
                                        set: set,
                                        exercise: currentExercise,
                                        viewModel: viewModel
                                    )
                                    .padding(.horizontal)
                                }
                                
                                Button(action: {
                                    viewModel.addSetToCurrentExercise()
                                }) {
                                    HStack {
                                        Image(systemName: "plus")
                                            .foregroundColor(.appPrimaryGreen)
                                        Text("Add Set")
                                            .foregroundColor(.appPrimaryGreen)
                                    }
                                    .font(.subheadline)
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                    
                    // Bottom navigation
                    HStack(spacing: 16) {
                        Button(action: {
                            viewModel.previousExercise()
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.appTextPrimary)
                                Text("Previous")
                                    .foregroundColor(.appTextPrimary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.appCardBackground)
                            .cornerRadius(12)
                        }
                        .disabled(!viewModel.canGoToPrevious)
                        .opacity(viewModel.canGoToPrevious ? 1.0 : 0.5)
                        
                        if viewModel.isLastExercise {
                            Button(action: {
                                showingFinishAlert = true
                            }) {
                                Text("Finish Workout")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.appPrimaryGreen)
                                    .cornerRadius(12)
                            }
                        } else {
                            Button(action: {
                                viewModel.nextExercise()
                            }) {
                                Text("Next >")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.appPrimaryGreen)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
        .alert("Finish Workout?", isPresented: $showingFinishAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Finish") {
                finishWorkout()
            }
        } message: {
            Text("Are you sure you want to finish this workout?")
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
    }
    
    private var progress: Double {
        guard exercises.count > 0 else { return 0 }
        return Double(viewModel.currentExerciseIndex + 1) / Double(exercises.count)
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
                    ]
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
