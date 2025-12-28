//
//  SetCompletionRow.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import SwiftUI

struct SetCompletionRow: View {
    let set: ExerciseSet
    let exercise: Exercise
    @ObservedObject var viewModel: ActiveWorkoutViewModel
    
    @State private var repsText: String = ""
    @State private var weightText: String = ""
    
    var body: some View {
        HStack(spacing: 16) {
            // Set number
            Text("\(set.setNumber)")
                .font(.headline)
                .foregroundColor(.appTextSecondary)
                .frame(width: 40)
            
            // Weight input (if applicable)
            if exercise.equipment != .bodyweight {
                TextField("LBS", text: $weightText)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 80)
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
            } else {
                Text("LBS")
                    .font(.subheadline)
                    .foregroundColor(.appTextSecondary)
                    .frame(width: 80)
            }
            
            // Reps input
            if let targetReps = set.targetReps {
                TextField("REPS", text: $repsText)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 80)
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
            } else {
                // Timed set - no reps input
                Text("REPS")
                    .font(.subheadline)
                    .foregroundColor(.appTextSecondary)
                    .frame(width: 80)
            }
            
            Spacer()
            
            // Completion toggle
            Button(action: {
                viewModel.toggleSetCompletion(setId: set.id, exerciseId: exercise.id)
            }) {
                Circle()
                    .fill(viewModel.isSetCompleted(setId: set.id) ? Color.appPrimaryGreen : Color.clear)
                    .overlay(
                        Circle()
                            .stroke(viewModel.isSetCompleted(setId: set.id) ? Color.appPrimaryGreen : Color.appInactiveGray, lineWidth: 2)
                    )
                    .frame(width: 32, height: 32)
                    .overlay {
                        if viewModel.isSetCompleted(setId: set.id) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.black)
                                .font(.system(size: 14, weight: .bold))
                        }
                    }
            }
        }
        .padding(.vertical, 8)
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
            sets: []
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
