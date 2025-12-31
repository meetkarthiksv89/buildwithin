//
//  WeekHeader.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import SwiftUI

struct WeekHeader: View {
    let week: Week
    let completedDaysCount: Int
    @Binding var isExpanded: Bool
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                isExpanded.toggle()
            }
        }) {
            HStack {
                Text("WEEK \(week.weekNumber)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.appTextPrimary)
                
                Spacer()
                
                Text("\(completedDaysCount)/\(week.totalDays) completed")
                    .font(.subheadline)
                    .foregroundColor(.appTextSecondary)
                
                Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.appTextSecondary)
                    .padding(.leading, 8)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
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
                Rectangle()
                    .stroke(Color.appPrimaryGreen.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 0) {
        WeekHeader(
            week: Week(
                weekNumber: 1,
                days: [
                    WorkoutDay(
                        id: "day1",
                        programId: "prog1",
                        dayNumber: 1,
                        title: "Test Day",
                        description: nil,
                        estimatedDurationMinutes: 30,
                        isRestDay: false
                    )
                ]
            ),
            completedDaysCount: 3,
            isExpanded: .constant(true)
        )
        
        WeekHeader(
            week: Week(
                weekNumber: 2,
                days: []
            ),
            completedDaysCount: 0,
            isExpanded: .constant(false)
        )
    }
    .background(Color.appBackground)
}
