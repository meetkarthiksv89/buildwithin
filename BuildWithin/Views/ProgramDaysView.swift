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
    @State private var expandedWeeks: Set<Int> = []
    
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
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(viewModel.weeks) { week in
                        VStack(spacing: 0) {
                            // Week header
                            WeekHeader(
                                week: week,
                                completedDaysCount: week.completedDaysCount(using: { viewModel.isDayCompleted($0) }),
                                isExpanded: Binding(
                                    get: { expandedWeeks.contains(week.weekNumber) },
                                    set: { isExpanded in
                                        if isExpanded {
                                            expandedWeeks.insert(week.weekNumber)
                                        } else {
                                            expandedWeeks.remove(week.weekNumber)
                                        }
                                    }
                                )
                            )
                            
                            // Days in this week (conditionally shown)
                            if expandedWeeks.contains(week.weekNumber) {
                                VStack(spacing: 16) {
                                    ForEach(week.days) { day in
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
                                    .padding(.horizontal)
                                }
                                .padding(.vertical, 16)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                        
                        // Add spacing between weeks (but not after the last week)
                        if let lastWeek = viewModel.weeks.last, week.id != lastWeek.id {
                            Divider()
                                .background(Color.appTextSecondary.opacity(0.3))
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                        }
                    }
                }
                .padding(.vertical)
            }
            .onAppear {
                // Expand first week by default
                if expandedWeeks.isEmpty, let firstWeek = viewModel.weeks.first {
                    expandedWeeks.insert(firstWeek.weekNumber)
                }
            }
        }
        .navigationTitle(program.title)
        .navigationBarTitleDisplayMode(.large)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.appTextPrimary)
                }
            }
        }
    }
    
    private func isToday(_ workoutDay: WorkoutDay) -> Bool {
        // Simple logic: first incomplete day is "today"
        // In a real app, this would use actual date tracking
        let completedDays = viewModel.days.filter { viewModel.isDayCompleted($0) }
        if let firstIncompleteIndex = viewModel.days.firstIndex(where: { !viewModel.isDayCompleted($0) }) {
            return viewModel.days[firstIncompleteIndex].id == workoutDay.id
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
