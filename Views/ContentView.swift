//
//  ContentView.swift
//  SurveyApp
//
//  Created by Abhishek Tripathi Kuberji on 23/02/26.
//

import SwiftUI

// The root view of the application.
// It sets up the dependency injection and manages the tab navigation between the Form and the List.
struct ContentView: View {
    @State private var selectedTab = 0
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        // Dependency Injection Root for this screen
        let repository = SurveyRepository()
        let viewModel = SurveyFormViewModel(repository: repository)
        
        TabView(selection: $selectedTab) {
            SurveyFormView(viewModel: viewModel, selectedTab: $selectedTab)
                .tag(0)
            
            SurveyListView(selectedTab: $selectedTab)
                .tag(1)
            
            SurveyAnalyticsView(selectedTab: $selectedTab)
                .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .background((colorScheme == .dark ? Color.black : Color(red: 0.925, green: 0.941, blue: 0.953)).ignoresSafeArea())
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    ContentView()
}
