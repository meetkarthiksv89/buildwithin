//
//  Program.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import Foundation

struct Program: Codable, Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let description: String?
    let category: ProgramCategory
    let coverImageURL: String
    let totalDays: Int
    let isActive: Bool
}
