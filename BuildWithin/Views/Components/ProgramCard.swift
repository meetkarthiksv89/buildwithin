//
//  ProgramCard.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import SwiftUI

struct ProgramCard: View {
    let program: Program
    
    var body: some View {
        HStack(spacing: 16) {
            // Cover image placeholder
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.appCardBackground)
                .frame(width: 80, height: 80)
                .overlay {
                    Image(systemName: "figure.strengthtraining.traditional")
                        .foregroundColor(.appTextSecondary)
                        .font(.system(size: 32))
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(program.title)
                    .font(.headline)
                    .foregroundColor(.appTextPrimary)
                
                Text(program.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.appLightGreen)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.appCardBackground)
        .cornerRadius(16)
    }
}

#Preview {
    ProgramCard(program: Program(
        id: "test",
        title: "Fat Loss 4-Day Split",
        subtitle: "Push • Pull • Legs • Full Body",
        description: nil,
        category: .strength,
        coverImageURL: "",
        totalDays: 4,
        isActive: true
    ))
    .background(Color.appBackground)
    .padding()
}
