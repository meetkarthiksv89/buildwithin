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
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.days) { day in
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
                .padding(.vertical)
            }
        }
        .navigationTitle(program.title)
        .navigationBarTitleDisplayMode(.large)
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
