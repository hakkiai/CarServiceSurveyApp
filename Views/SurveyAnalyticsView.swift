//
//  SurveyAnalyticsView.swift
//  SurveyApp
//
//  Created by Nettem Taraka Ram Teja on 23/02/26.
//

import SwiftUI
import CoreData
import Charts

/// A view that displays statistics and analytics for the submitted surveys.
/// Uses animated bars and summary cards to visualize the data.
struct SurveyAnalyticsView: View {
    @Binding var selectedTab: Int
    @Environment(\.colorScheme) var colorScheme
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SurveyEntity.createdAt, ascending: true)],
        animation: .default)
    private var surveys: FetchedResults<SurveyEntity>
    
    @State private var animateStats = false
    @State private var selectedPieSegment: Int? = nil
    
    private var backgroundColor: Color {
        colorScheme == .dark ? Color.black : Color(red: 0.925, green: 0.941, blue: 0.953)
    }
    
    // MARK: - Computed Statistics
    private var totalSurveys: Int { surveys.count }
    
    private var avgService: Double {
        guard !surveys.isEmpty else { return 0 }
        let total = surveys.reduce(0.0) { $0 + Double($1.serviceRating) }
        return total / Double(surveys.count)
    }
    
    private var avgSupport: Double {
        guard !surveys.isEmpty else { return 0 }
        let total = surveys.reduce(0.0) { $0 + Double($1.supportRating) }
        return total / Double(surveys.count)
    }
    
    private var avgSatisfaction: Double {
        guard !surveys.isEmpty else { return 0 }
        let total = surveys.reduce(0.0) { $0 + $1.serviceRating }
        return total / Double(surveys.count)
    }
    
    // MARK: - Chart Data Helpers
    
    /// Maps a 1–5 rating to a representative color used in charts.
    private func ratingColor(_ rating: Int) -> Color {
        switch rating {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .green
        case 5: return .blue
        default: return .gray
        }
    }
    
    private var satisfactionDistribution: [PieData] {
        var counts = [1: 0, 2: 0, 3: 0, 4: 0, 5: 0]
        for survey in surveys {
            counts[Int(survey.satisfactionRating), default: 0] += 1
        }
        let total = Double(surveys.count)
        guard total > 0 else { return [] }
        
        return counts.sorted(by: { $0.key < $1.key }).map { (rating, count) in
            PieData(
                label: "\(rating) Stars",
                value: Double(count),
                percentage: Double(count) / total,
                color: ratingColor(rating)
            )
        }
    }
    
    private var trendData: [TrendData] {
        let sorted = surveys.sorted { ($0.createdAt ?? Date()) < ($1.createdAt ?? Date()) }
        // Take last 10 for readability
        let recent = sorted.suffix(10)
        return recent.enumerated().map { index, survey in
            TrendData(index: index + 1, rating: survey.satisfactionRating)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack(spacing: 16) {
                        Button(action: {
                            withAnimation { selectedTab = 0 }
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.primary)
                                .padding(10)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                        }
                        
                        Text("Analytics")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.primary.opacity(0.8))
                        
                        Spacer()
                    }
                    .padding()
                    .background(backgroundColor)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 5)
                    .zIndex(1)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            if surveys.isEmpty {
                                ContentUnavailableView("No Data Yet", systemImage: "chart.bar.xaxis", description: Text("Submit surveys to see analytics."))
                                    .padding(.top, 50)
                            } else {
                                // 1. Key Metrics Row
                                HStack(spacing: 12) {
                                    SummaryCard(title: "Total", value: "\(totalSurveys)", icon: "doc.text.fill", color: .blue)
                                    SummaryCard(title: "Avg Score", value: String(format: "%.1f", avgSatisfaction), icon: "star.fill", color: .yellow)
                                }
                                .padding(.horizontal)
                                
                                // 2. Satisfaction Distribution (Pie Chart)
                                GlassSection(title: "Satisfaction Breakdown") {
                                    HStack {
                                        CustomPieChart(data: satisfactionDistribution, animate: animateStats)
                                            .frame(width: 150, height: 150)
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            ForEach(satisfactionDistribution) { item in
                                                HStack {
                                                    Circle()
                                                        .fill(item.color)
                                                        .frame(width: 8, height: 8)
                                                    Text(item.label)
                                                        .font(.caption)
                                                        .foregroundColor(.secondary)
                                                    Spacer()
                                                    Text("\(Int(item.value))")
                                                        .font(.caption)
                                                        .fontWeight(.bold)
                                                }
                                            }
                                        }
                                        .padding(.leading, 12)
                                    }
                                    .padding(.vertical, 8)
                                }
                                .padding(.horizontal)
                                
                                // 3. Category Comparison (Bar Chart)
                                GlassSection(title: "Category Performance") {
                                    Chart {
                                        BarMark(x: .value("Category", "Service"), y: .value("Rating", avgService))
                                            .foregroundStyle(Gradient(colors: [.blue.opacity(0.6), .blue]))
                                        BarMark(x: .value("Category", "Support"), y: .value("Rating", avgSupport))
                                            .foregroundStyle(Gradient(colors: [.purple.opacity(0.6), .purple]))
                                        BarMark(x: .value("Category", "Overall"), y: .value("Rating", avgSatisfaction))
                                            .foregroundStyle(Gradient(colors: [.green.opacity(0.6), .green]))
                                    }
                                    .chartYScale(domain: 0...5)
                                    .frame(height: 200)
                                }
                                .padding(.horizontal)
                                
                                // 4. Recent Trends (Line Chart)
                                GlassSection(title: "Recent Trends (Last 10)") {
                                    Chart(trendData) { item in
                                        LineMark(x: .value("Index", item.index), y: .value("Rating", item.rating))
                                            .interpolationMethod(.catmullRom)
                                            .symbol(Circle())
                                    }
                                    .chartYScale(domain: 1...5)
                                    .frame(height: 150)
                                    .padding(.vertical, 8)
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 20)
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                    animateStats = true
                }
            }
            .onDisappear {
                animateStats = false
            }
        }
    }
}

/// A custom animated progress bar component.
struct AnimatedBar: View {
    let label: String
    let value: Double
    let color: Color
    let animate: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                Text(String(format: "%.1f", value))
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(color)
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.secondary.opacity(0.1))
                        .frame(height: 12)
                    
                    Capsule()
                        .fill(
                            LinearGradient(colors: [color.opacity(0.7), color], startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(width: animate ? (CGFloat(value) / 5.0) * geo.size.width : 0, height: 12)
                }
            }
            .frame(height: 12)
        }
    }
}
// MARK: - Supporting Models

/// Represents a single pie segment for satisfaction distribution
struct PieData: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
    let percentage: Double
    let color: Color
}

/// Represents a point in the satisfaction trend over time
struct TrendData: Identifiable {
    let id = UUID()
    let index: Int
    let rating: Double
}

struct SummaryCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)
                    .padding(8)
                    .background(color.opacity(0.1))
                    .clipShape(Circle())
                Spacer()
            }
            
            VStack(alignment: .leading) {
                Text(value)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct CustomPieChart: View {
    let data: [PieData]
    let animate: Bool
    
    var body: some View {
        ZStack {
            ForEach(0..<data.count, id: \.self) { index in
                let start = self.startAngle(for: index)
                let end = self.endAngle(for: index)
                
                Circle()
                    .trim(from: start, to: animate ? end : start)
                    .stroke(
                        data[index].color,
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut(duration: 1.0).delay(Double(index) * 0.1), value: animate)
            }
            
            // Center Text
            VStack {
                Text("Ratings")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private func startAngle(for index: Int) -> CGFloat {
        var total: Double = 0
        for i in 0..<index {
            total += data[i].percentage
        }
        return CGFloat(total)
    }
    
    private func endAngle(for index: Int) -> CGFloat {
        return startAngle(for: index) + CGFloat(data[index].percentage)
    }
}
