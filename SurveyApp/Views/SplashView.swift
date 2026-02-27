//
//  SplashView.swift
//  SurveyApp
//
//  Created by Abhishek Tripathi Kuberji on 23/02/26.
//

import SwiftUI

// The initial launch screen of the application.
// Displays the app logo and title with an animation before transitioning to the main content.
struct SplashView: View {
    @Binding var isActive: Bool
    @State private var opacity = 0.0
    @State private var scale = 0.8
    
    var body: some View {
        ZStack {
            // Background matching the app theme
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Image("AppLogo") // Ensure your image in Assets is named "AppLogo"
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                Text("Car Service Survey")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            .opacity(opacity)
            .scaleEffect(scale)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                opacity = 1.0
                scale = 1.0
            }
            
            // Transition to main app after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeIn(duration: 0.3)) {
                    isActive = false
                }
            }
        }
    }
}
