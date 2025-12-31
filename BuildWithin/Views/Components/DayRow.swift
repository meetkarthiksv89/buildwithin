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
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("TODAY")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.appPrimaryGreen)
                    
                    Text("\(String(format: "%02d", workoutDay.dayNumber))")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.appTextPrimary)
                }
                .frame(width: 60)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(workoutDay.title)
                        .font(.headline)
                        .foregroundColor(.appTextPrimary)
                    
                    if let description = workoutDay.description {
                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(.appTextSecondary)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption)
                            .foregroundColor(.appTextSecondary)
                        Text("\(workoutDay.estimatedDurationMinutes) min")
                            .font(.caption)
                            .foregroundColor(.appTextSecondary)
                    }
                }
                
                Spacer()
                
                Circle()
                    .fill(Color.appPrimaryGreen)
                    .frame(width: 44, height: 44)
                    .overlay {
                        Image(systemName: "play.fill")
                            .foregroundColor(.black)
                            .font(.system(size: 16))
                    }
            }
            .padding()
            .background(Color.appCardBackground)
            .overlay(
                Rectangle()
                    .fill(Color.appPrimaryGreen)
                    .frame(width: 4)
                    .padding(.vertical, 8),
                alignment: .leading
            )
            .cornerRadius(12)
        } else {
            // Regular day row
            HStack {
                Text("DAY \(String(format: "%02d", workoutDay.dayNumber))")
                    .font(.caption)
                    .foregroundColor(.appTextSecondary)
                    .frame(width: 80, alignment: .leading)
                
                Text(workoutDay.title)
                    .font(.body)
                    .foregroundColor(.appTextPrimary)
                
                Spacer()
                
                if isCompleted {
                    Circle()
                        .fill(Color.appPrimaryGreen)
                        .frame(width: 24, height: 24)
                        .overlay {
                            Image(systemName: "checkmark")
                                .foregroundColor(.black)
                                .font(.system(size: 12))
                        }
                } else {
                    Circle()
                        .stroke(Color.appInactiveGray, lineWidth: 2)
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.vertical, 8)
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
