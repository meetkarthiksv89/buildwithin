//
//  ProgramsListViewModel.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import Foundation
import Combine

@MainActor
class ProgramsListViewModel: ObservableObject {
    @Published var programs: [ProgramContent] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    let repository: ProgramRepository
    
    init(repository: ProgramRepository) {
        self.repository = repository
    }
    
    func loadPrograms() async {
        isLoading = true
        errorMessage = nil
        
        do {
            programs = try await repository.loadPrograms()
            print("Successfully loaded \(programs.count) programs")
        } catch {
            let errorDesc = error.localizedDescription
            errorMessage = errorDesc
            print("Error loading programs: \(error)")
            print("Error details: \(error)")
        }
        
        isLoading = false
    }
}
