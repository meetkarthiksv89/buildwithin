//  ProgramsListView.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import SwiftUI

struct ProgramsListView: View {
    @StateObject private var viewModel: ProgramsListViewModel
    let progressStore: ProgressStoreProtocol
    
    init(repository: ProgramRepository, progressStore: ProgressStoreProtocol) {
        _viewModel = StateObject(wrappedValue: ProgramsListViewModel(repository: repository))
        self.progressStore = progressStore
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .tint(.appPrimaryGreen)
                        Text("Loading programs...")
                            .foregroundColor(.appTextSecondary)
                    }
                } else if let errorMessage = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 48))
                            .foregroundColor(.appTextSecondary)
                        Text("Error loading programs")
                            .font(.headline)
                            .foregroundColor(.appTextPrimary)
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.appTextSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else {
                    VStack(spacing: 0) {
                        // Header
                        HStack {
                            Text("My Programs")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.appTextPrimary)
                            
                            Spacer()
                            
                            HStack(spacing: 12) {
                                NavigationLink(destination: WorkoutHistoryView(
                                    progressStore: progressStore,
                                    allPrograms: viewModel.programs
                                )) {
                                    Circle()
                                        .fill(Color.appCardBackground)
                                        .frame(width: 40, height: 40)
                                        .overlay {
                                            Image(systemName: "clock.fill")
                                                .foregroundColor(.appTextSecondary)
                                                .font(.system(size: 16))
                                        }
                                }
                                
                                Button(action: {}) {
                                    Circle()
                                        .fill(Color.appCardBackground)
                                        .frame(width: 40, height: 40)
                                        .overlay {
                                            Image(systemName: "person.fill")
                                                .foregroundColor(.appTextSecondary)
                                                .font(.system(size: 16))
                                        }
                                }
                            }
                        }
                        .padding()
                        
                        // Programs list
                        ScrollView {
                            VStack(spacing: 16) {
                                // CURRENT section
                                HStack {
                                    Text("CURRENT")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.appLightGreen)
                                    Spacer()
                                }
                                .padding(.horizontal)
                                
                                ForEach(viewModel.programs) { programContent in
                                    NavigationLink(destination: ProgramDaysView(
                                        program: programContent.program,
                                        repository: viewModel.repository,
                                        progressStore: progressStore,
                                        allPrograms: viewModel.programs
                                    )) {
                                        ProgramCard(program: programContent.program)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .padding(.horizontal)
                            }
                            .padding(.vertical)
                        }
                    }
                }
            }
            .task {
                await viewModel.loadPrograms()
            }
        }
    }
}

#Preview {
    ProgramsListView(repository: ProgramRepository(), progressStore: ProgressStore())
}
