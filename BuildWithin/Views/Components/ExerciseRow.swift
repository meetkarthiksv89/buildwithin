//
//  ExerciseRow.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import SwiftUI

struct ExerciseRow: View {
    let exercise: Exercise
    
    var body: some View {
        HStack(spacing: 16) {
            Text(String(format: "%02d", exercise.order))
                .font(.caption)
                .foregroundColor(.appTextSecondary)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.name)
                    .font(.headline)
                    .foregroundColor(.appTextPrimary)
                
                Text(exerciseSummary)
                    .font(.subheadline)
                    .foregroundColor(.appTextSecondary)
            }
            
            Spacer()
            
            if let videoLink = exercise.videoLink, let url = URL(string: videoLink) {
                Link(destination: url) {
                    Image(systemName: "play.circle.fill")
                        .foregroundColor(.appPrimaryGreen)
                        .font(.system(size: 24))
                }
            } else {
                Image(systemName: "play.circle")
                    .foregroundColor(.appInactiveGray)
                    .font(.system(size: 24))
            }
        }
        .padding(.vertical, 8)
    }
    
    private var exerciseSummary: String {
        let setsCount = exercise.sets.count
        if let firstSet = exercise.sets.first, let reps = firstSet.targetReps {
            return "\(setsCount) sets x \(reps) reps"
        } else if let firstSet = exercise.sets.first, firstSet.targetReps == nil {
            return "\(setsCount) sets"
        }
        return "\(setsCount) sets"
    }
}

#Preview {
    ExerciseRow(exercise: Exercise(
        id: "ex1",
        workoutDayId: "day1",
        name: "Bench Press",
        order: 1,
        equipment: .barbell,
        restSeconds: 90,
        targetMuscleGroups: [.chest, .arms],
        sets: [
            ExerciseSet(id: "s1", setNumber: 1, targetReps: 8, targetWeight: nil),
            ExerciseSet(id: "s2", setNumber: 2, targetReps: 8, targetWeight: nil),
            ExerciseSet(id: "s3", setNumber: 3, targetReps: 8, targetWeight: nil)
        ],
        videoLink: "https://www.youtube.com/watch?v=k9MY1ijAvGo"
    ))
    .padding()
    .background(Color.appBackground)
}
