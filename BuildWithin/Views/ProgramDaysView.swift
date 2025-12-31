//
//  ProgramDaysView.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import SwiftUI

struct ProgramDaysView: View {
    let program: Program
    let repository: ProgramRepository
    let progressStore: ProgressStoreProtocol
    let allPrograms: [ProgramContent]
    
    @StateObject private var viewModel: ProgramDaysViewModel
    
    init(program: Program, repository: ProgramRepository, progressStore: ProgressStoreProtocol, allPrograms: [ProgramContent]) {
        self.program = program
        self.repository = repository
        self.progressStore = progressStore
        self.allPrograms = allPrograms
        _viewModel = StateObject(wrappedValue: ProgramDaysViewModel(
            program: program,
            repository: repository,
            progressStore: progressStore,
            allPrograms: allPrograms
        ))
    }
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    if let description = program.description, !description.isEmpty {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(description)
                                .font(.body)
                                .foregroundColor(.appTextSecondary)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 16)
                    }
                    
                    
                    ForEach(viewModel.days) { day in
                        if day.isRestDay {
                            // Rest days are not tappable
                            DayRow(
                                workoutDay: day,
                                isCompleted: viewModel.isDayCompleted(day),
                                isToday: isToday(day)
                            )
                        } else {
                            // Workout days are tappable
                            NavigationLink(destination: WorkoutDayDetailView(
                                workoutDay: day,
                                program: program,
                                repository: repository,
                                progressStore: progressStore,
                                allPrograms: allPrograms
                            )) {
                                DayRow(
                                    workoutDay: day,
                                    isCompleted: viewModel.isDayCompleted(day),
                                    isToday: isToday(day)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 8)
                .padding(.bottom, 20)
            }
        }
        .navigationTitle(program.title)
        .navigationBarTitleDisplayMode(.large)
        .toolbar(.hidden, for: .tabBar)
    }
    
    private func isToday(_ workoutDay: WorkoutDay) -> Bool {
        // Rest days should never be marked as "today"
        if workoutDay.isRestDay {
            return false
        }
        
        let activeDays = viewModel.days.filter { !$0.isRestDay }
        
        // 1. If there are any incomplete days, the first one is "today"
        if let firstIncomplete = activeDays.first(where: { !viewModel.isDayCompleted($0) }) {
            return firstIncomplete.id == workoutDay.id
        }
        
        // 2. All days are completed (at least once).
        // We need to find the "edge" where the current round ends.
        // Identify this by finding the first day that was completed *after* the next day.
        // e.g., Day 1 (Jan 5) > Day 2 (Jan 1). Next is Day 2.
        
        for i in 0..<(activeDays.count - 1) {
            let currentDay = activeDays[i]
            let nextDay = activeDays[i+1]
            
            if let date1 = viewModel.getCompletionDate(for: currentDay),
               let date2 = viewModel.getCompletionDate(for: nextDay) {
                if date1 > date2 {
                    return nextDay.id == workoutDay.id
                }
            }
        }
        
        // 3. If dates are all in order (D1 < D2 < D3), it means we just finished a full round (or the last day).
        // The next day is the first day.
        if let firstDay = activeDays.first {
            return firstDay.id == workoutDay.id
        }
        
        return false
    }
}

#Preview {
    NavigationStack {
        ProgramDaysView(
            program: Program(
                id: "prog1",
                title: "5k Runner Prep",
                subtitle: "Running",
                description: "asdfasdfasdfasdfasdf",
                category: .running,
                coverImageURL: "",
                totalDays: 6,
                isActive: true
            ),
            repository: ProgramRepository(),
            progressStore: ProgressStore(),
            allPrograms: []
        )
    }
}
