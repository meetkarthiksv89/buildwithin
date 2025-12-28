//
//  NutritionView.swift
//  BuildWithin
//
//  Created by Karthik Venkatesh on 12/27/25.
//

import SwiftUI

struct NutritionView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    Image(systemName: "fork.knife")
                        .font(.system(size: 64))
                        .foregroundColor(.appTextSecondary)
                    
                    Text("Nutrition")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.appTextPrimary)
                    
                    Text("Coming soon...")
                        .font(.subheadline)
                        .foregroundColor(.appTextSecondary)
                }
            }
            .navigationTitle("Nutrition")
        }
    }
}

#Preview {
    NutritionView()
}
