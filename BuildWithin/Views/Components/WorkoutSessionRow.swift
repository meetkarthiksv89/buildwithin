//
//  WorkoutSessionRow.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import SwiftUI

struct WorkoutSessionRow: View {
    let session: WorkoutSession
    let programName: String
    let workoutDayName: String
    let duration: TimeInterval?
    let exerciseCount: Int
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                // Date and time
                HStack(spacing: 8) {
                    Text(formatDate(session.startTime))
                        .font(.headline)
                        .foregroundColor(.appTextPrimary)
                    
                    if let endTime = session.endTime {
                        Text("•")
                            .foregroundColor(.appTextSecondary)
                        
                        Text(formatTime(session.startTime))
                            .font(.subheadline)
                            .foregroundColor(.appTextSecondary)
                    }
                }
                
                // Program and workout day
                Text("\(programName) • \(workoutDayName)")
                    .font(.subheadline)
                    .foregroundColor(.appLightGreen)
                
                // Duration and exercise count
                HStack(spacing: 8) {
                    if let duration = duration {
                        HStack(spacing: 4) {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.appPrimaryGreen)
                                .font(.system(size: 12))
                            Text(formatDuration(duration))
                                .foregroundColor(.appTextSecondary)
                        }
                        .font(.caption)
                    }
                    
                    if duration != nil {
                        Text("•")
                            .foregroundColor(.appTextSecondary)
                            .font(.caption)
                    }
                    
                    Text("\(exerciseCount) exercise\(exerciseCount == 1 ? "" : "s")")
                        .foregroundColor(.appTextSecondary)
                        .font(.caption)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.appTextSecondary)
                .font(.system(size: 14))
        }
        .padding()
        .background(Color.appCardBackground)
        .cornerRadius(16)
    }
    
    private func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: date)
        }
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
            return "\(minutes) min"
        } else {
            return "\(seconds) sec"
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        WorkoutSessionRow(
            session: WorkoutSession(
                programId: "prog1",
                workoutDayId: "day1",
                startTime: Date(),
                endTime: Date().addingTimeInterval(2520)
            ),
            programName: "Fat Loss 4 Day",
            workoutDayName: "Upper Body Power",
            duration: 2520,
            exerciseCount: 3
        )
        
        WorkoutSessionRow(
            session: WorkoutSession(
                programId: "prog1",
                workoutDayId: "day1",
                startTime: Date().addingTimeInterval(-86400),
                endTime: Date().addingTimeInterval(-82800)
            ),
            programName: "Lean Gain 4 Week",
            workoutDayName: "Push Day",
            duration: 3600,
            exerciseCount: 4
        )
    }
    .padding()
    .background(Color.appBackground)
}
