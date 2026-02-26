//
//  SurveyListView.swift
//  SurveyApp
//
//  Created by Abhishek Tripathi Kuberji on 23/02/26.
//

import SwiftUI
import CoreData

struct SurveyListView: View {
    @Binding var selectedTab: Int
    @Environment(\.colorScheme) var colorScheme
    @State private var searchText = ""
    
    private var backgroundColor: Color {
        colorScheme == .dark ? Color.black : Color(red: 0.925, green: 0.941, blue: 0.953)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    // Header
                    HStack(spacing: 16) {
                        Button(action: {
                            withAnimation {
                                selectedTab = 0
                            }
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.primary)
                                .padding(10)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                        
                        Text("Submitted Surveys")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        
                        Spacer()
                    }
                    .padding()
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        TextField("Search by name or email...", text: $searchText)
                        
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(12)
                    .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    
                    FilteredSurveyList(filter: searchText)
                }
            }
            .toolbar(.hidden)
        }
    }
}

struct FilteredSurveyList: View {
    
    @FetchRequest var surveys: FetchedResults<SurveyEntity>
    
    init(filter: String) {
        let sortDescriptors = [NSSortDescriptor(keyPath: \SurveyEntity.createdAt, ascending: false)]
        
        if filter.isEmpty {
            _surveys = FetchRequest(sortDescriptors: sortDescriptors, animation: .default)
        } else {
            let predicate = NSPredicate(format: "name CONTAINS[cd] %@ OR email CONTAINS[cd] %@", filter, filter)
            _surveys = FetchRequest(sortDescriptors: sortDescriptors, predicate: predicate, animation: .default)
        }
    }
    
    var body: some View {
        List {
            ForEach(surveys) { survey in
                
                NavigationLink(
                    destination: SurveyDetailUIKitWrapper(survey: survey)
                ) {
                    
                    VStack(alignment: .leading, spacing: 6) {
                        
                        HStack {
                            Text(survey.name ?? "Unknown")
                                .font(.headline)
                            
                            Spacer()
                            
                            Text(survey.serviceDate ?? Date(), style: .date)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Text(survey.carModel ?? "")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Text(survey.email ?? "")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        HStack {
                            Label("\(survey.serviceRating)", systemImage: "star.fill")
                            Label("\(survey.supportRating)", systemImage: "phone.fill")
                            Label("\(survey.satisfactionRating)", systemImage: "hand.thumbsup.fill")
                        }
                        .font(.caption)
                        .foregroundStyle(.blue)
                        .padding(.top, 4)
                    }
                    .padding(.vertical, 4)
                }
                .listRowBackground(Color.clear)
            }
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .overlay {
            if surveys.isEmpty {
                ContentUnavailableView(
                    "No Surveys Found",
                    systemImage: "doc.text.magnifyingglass",
                    description: Text("Try a different search term.")
                )
            }
        }
    }
}
