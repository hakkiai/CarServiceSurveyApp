//
//  SurveyAppApp.swift
//  SurveyApp
//
//  Created by Abhishek Tripathi Kuberji on 23/02/26.
//

import SwiftUI
import CoreData

/// The entry point of the SwiftUI application.
/// Manages the app lifecycle and the initial transition from SplashView to ContentView.
@main
struct SurveyAppApp: App {
    let persistenceController = PersistenceController.shared
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashView(isActive: $showSplash)
            } else {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .tint(.blue) // Consistent accent color
            }
        }
    }
}
