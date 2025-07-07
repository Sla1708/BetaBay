//
//  OnboardingStage.swift
//  BetaBay
//
//  Created by Sayan on 01.07.2025.
//


import SwiftUI

enum OnboardingStage {
    case welcome, explanations, content
}

struct RootView: View {
    @State private var stage: OnboardingStage = .welcome

    var body: some View {
        Group {
            switch stage {
            case .welcome:
                WelcomeView {
                    stage = .explanations
                }
            case .explanations:
                ExplanationsView(onFinish: {
                    stage = .content
                })
            case .content:
                ContentView()
            }
        }
    }
}