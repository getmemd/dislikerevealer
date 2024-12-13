//
//  AppView.swift
//  DislikeRevealer (iOS)
//
//  Created by Adilkhan Medeuyev on 14.12.2024.
//

import SwiftUI

struct AppView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    var body: some View {
        if hasSeenOnboarding {
            DislikeCheckerView()
        } else {
            OnboardingView()
        }
    }
}

#Preview {
    AppView()
}
