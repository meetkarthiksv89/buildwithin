//
//  SetCompletionRow.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import SwiftUI

struct CompletionButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { oldValue, newValue in
                isPressed = newValue
            }
    }
}

struct SetCompletionRow: View {
    let set: ExerciseSet
    let exercise: Exercise
    @ObservedObject var viewModel: ActiveWorkoutViewModel
    
    @State private var repsText: String = ""
    @State private var weightText: String = ""
    @State private var isPressed = false
    
    private var isCompleted: Bool {
        viewModel.isSetCompleted(setId: set.id)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Set number badge - Spotify style
            ZStack {
                Circle()
                    .fill(isCompleted ? Color.appPrimaryGreen.opacity(0.2) : Color.appCardBackground)
                    .frame(width: 40, height: 40)
                
                Text("\(set.setNumber)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isCompleted ? .appPrimaryGreen : .appTextSecondary)
            }
            
            // Weight and Reps inputs - Card style
            HStack(spacing: 12) {
                // Weight input
                if exercise.equipment != .bodyweight {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Weight")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.appTextSecondary)
                        
                        TextField("0", text: $weightText)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.appTextPrimary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(Color.appBackground)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(isCompleted ? Color.appPrimaryGreen.opacity(0.3) : Color.appInactiveGray.opacity(0.3), lineWidth: 1)
                            )
                            .onChange(of: weightText) { oldValue, newValue in
                                if let weight = Double(newValue) {
                                    viewModel.updateSetWeight(setId: set.id, exerciseId: exercise.id, weight: weight)
                                } else {
                                    viewModel.updateSetWeight(setId: set.id, exerciseId: exercise.id, weight: nil)
                                }
                            }
                            .onAppear {
                                if let log = viewModel.getSetLog(setId: set.id), let weight = log.completedWeight {
                                    weightText = String(format: "%.0f", weight)
                                }
                            }
                    }
                }
                
                // Reps input
                if let targetReps = set.targetReps {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Reps")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.appTextSecondary)
                        
                        TextField("0", text: $repsText)
                            .keyboardType(.numberPad)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.appTextPrimary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(Color.appBackground)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(isCompleted ? Color.appPrimaryGreen.opacity(0.3) : Color.appInactiveGray.opacity(0.3), lineWidth: 1)
                            )
                            .onChange(of: repsText) { oldValue, newValue in
                                if let reps = Int(newValue) {
                                    viewModel.updateSetReps(setId: set.id, exerciseId: exercise.id, reps: reps)
                                } else {
                                    viewModel.updateSetReps(setId: set.id, exerciseId: exercise.id, reps: nil)
                                }
                            }
                            .onAppear {
                                if let log = viewModel.getSetLog(setId: set.id), let reps = log.completedReps {
                                    repsText = String(reps)
                                } else if let targetReps = set.targetReps {
                                    repsText = String(targetReps)
                                }
                            }
                    }
                }
            }
            
            Spacer()
            
            // Completion indicator - Spotify style checkmark with proper tap target
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    viewModel.toggleSetCompletion(setId: set.id, exerciseId: exercise.id)
                }
            }) {
                ZStack {
                    Circle()
                        .fill(isCompleted ? Color.appPrimaryGreen : Color.clear)
                        .frame(width: 36, height: 36)
                        .overlay(
                            Circle()
                                .stroke(isCompleted ? Color.appPrimaryGreen : Color.appInactiveGray, lineWidth: 2)
                        )
                    
                    if isCompleted {
                        Image(systemName: "checkmark")
                            .foregroundColor(.black)
                            .font(.system(size: 14, weight: .bold))
                    }
                }
                .frame(width: 48, height: 48)
                .contentShape(Circle())
            }
            .buttonStyle(CompletionButtonStyle(isPressed: $isPressed))
        }
        .padding(16)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.appPrimaryGreen.opacity(0.15),
                    Color.appCardBackground
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isCompleted ? Color.appPrimaryGreen.opacity(0.3) : Color.appPrimaryGreen.opacity(0.2), lineWidth: 1.5)
        )
        .cornerRadius(12)
        .opacity(isCompleted ? 1.0 : 0.95)
    }
}

#Preview {
    SetCompletionRow(
        set: ExerciseSet(id: "s1", setNumber: 1, targetReps: 10, targetWeight: nil),
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
        viewModel: ActiveWorkoutViewModel(
            exercises: [],
            programId: "prog1",
            workoutDayId: "day1",
            progressStore: ProgressStore()
        )
    )
    .padding()
    .background(Color.appBackground)
}
