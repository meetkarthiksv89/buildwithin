//
//  ProgramRepository.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import Foundation
import Combine

@MainActor
class ProgramRepository: ObservableObject {
    private let bundle: Bundle
    
    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }
    
    func loadPrograms() async throws -> [ProgramContent] {
        // Try loading with subdirectory first, then without
        var indexURL = bundle.url(forResource: "program_index", withExtension: "json", subdirectory: "Programs")
        if indexURL == nil {
            indexURL = bundle.url(forResource: "program_index", withExtension: "json")
        }
        
        guard let indexURL = indexURL else {
            // List all JSON files in bundle for debugging
            if let resourcePath = bundle.resourcePath {
                print("Available resources: \(try? FileManager.default.contentsOfDirectory(atPath: resourcePath))")
            }
            throw ProgramRepositoryError.indexNotFound
        }
        
        let indexData = try Data(contentsOf: indexURL)
        let index = try JSONDecoder().decode(ProgramIndex.self, from: indexData)
        
        // Load each program file
        var programs: [ProgramContent] = []
        
        for fileName in index.programFiles {
            let baseName = fileName.replacingOccurrences(of: ".json", with: "")
            var programURL = bundle.url(forResource: baseName, withExtension: "json", subdirectory: "Programs")
            
            if programURL == nil {
                programURL = bundle.url(forResource: baseName, withExtension: "json")
            }
            
            guard let programURL = programURL else {
                print("Warning: Could not find program file: \(fileName)")
                continue
            }
            
            let programData = try Data(contentsOf: programURL)
            let program = try JSONDecoder().decode(ProgramContent.self, from: programData)
            programs.append(program)
        }
        
        return programs
    }
    
    func days(for programId: String, in programs: [ProgramContent]) -> [WorkoutDay] {
        guard let program = programs.first(where: { $0.program.id == programId }) else {
            return []
        }
        return program.workoutDays.sorted { $0.dayNumber < $1.dayNumber }
    }
    
    func exercises(for workoutDayId: String, in programs: [ProgramContent]) -> [Exercise] {
        var allExercises: [Exercise] = []
        for program in programs {
            let dayExercises = program.exercises.filter { $0.workoutDayId == workoutDayId }
            allExercises.append(contentsOf: dayExercises)
        }
        return allExercises.sorted { $0.order < $1.order }
    }
}

enum ProgramRepositoryError: LocalizedError {
    case indexNotFound
    case programFileNotFound(String)
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .indexNotFound:
            return "Program index file not found"
        case .programFileNotFound(let fileName):
            return "Program file not found: \(fileName)"
        case .decodingError(let error):
            return "Failed to decode program: \(error.localizedDescription)"
        }
    }
}
