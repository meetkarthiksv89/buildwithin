//
//  DayRow.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import SwiftUI

struct DayRow: View {
    let workoutDay: WorkoutDay
    let isCompleted: Bool
    let isToday: Bool
    
    var body: some View {
        if isToday && !workoutDay.isRestDay {
            // Highlighted "TODAY" row (only for workout days)
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("DAY")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.appPrimaryGreen)
                    
                    Text("\(String(format: "%02d", workoutDay.dayNumber))")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.appTextPrimary)
                }
                .frame(width: 60)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(workoutDay.title)
                        .font(.headline)
                        .foregroundColor(.appTextPrimary)
                    
                    if let description = workoutDay.description {
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.appTextSecondary)
                    }
                    
                    HStack(spacing: 6) {
                        Image(systemName: "clock")
                            .font(.caption)
                            .foregroundColor(.appTextSecondary)
                        Text("\(workoutDay.estimatedDurationMinutes) min")
                            .font(.caption)
                            .foregroundColor(.appTextSecondary)
                    }
                    .padding(.top, 4)
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.appCardBackground)
            .overlay(
                Rectangle()
                    .fill(Color.appPrimaryGreen)
                    .frame(width: 4)
                    .padding(.vertical, 12),
                alignment: .leading
            )
            .cornerRadius(12)
        } else {
            // Regular day row
            HStack(spacing: 12) {
                Text("DAY \(String(format: "%02d", workoutDay.dayNumber))")
                    .font(.caption)
                    .foregroundColor(workoutDay.isRestDay ? .appTextSecondary.opacity(0.7) : .appTextSecondary)
                    .frame(width: 80, alignment: .leading)
                
                Text(workoutDay.title)
                    .font(.body)
                    .foregroundColor(workoutDay.isRestDay ? .appTextPrimary.opacity(0.5) : .appTextPrimary)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(workoutDay.isRestDay ? Color.appCardBackground.opacity(0.5) : Color.appCardBackground)
            .cornerRadius(12)
            .opacity(workoutDay.isRestDay ? 0.6 : 1.0)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        DayRow(
            workoutDay: WorkoutDay(
                id: "day1",
                programId: "prog1",
                dayNumber: 3,
                title: "Interval Training",
                description: "High intensity intervals",
                estimatedDurationMinutes: 35,
                isRestDay: false
            ),
            isCompleted: false,
            isToday: true
        )
        
        DayRow(
            workoutDay: WorkoutDay(
                id: "day2",
                programId: "prog1",
                dayNumber: 1,
                title: "The First Steps",
                description: nil,
                estimatedDurationMinutes: 30,
                isRestDay: false
            ),
            isCompleted: true,
            isToday: false
        )
        
        DayRow(
            workoutDay: WorkoutDay(
                id: "day3",
                programId: "prog1",
                dayNumber: 4,
                title: "Long Run",
                description: nil,
                estimatedDurationMinutes: 45,
                isRestDay: false
            ),
            isCompleted: false,
            isToday: false
        )
    }
    .padding()
    .background(Color.appBackground)
}
