//
//  SurveyFormView.swift
//  SurveyApp
//
//  Created by Abhishek Tripathi Kuberji on 23/02/26.
//

import SwiftUI

// The main view that presents the survey form to the user.
// It handles user input, validation feedback, and navigation to the history view.
struct SurveyFormView: View {
    @StateObject var viewModel: SurveyFormViewModel
    @Binding var selectedTab: Int
    @Environment(\.colorScheme) var colorScheme
    
    // Computes the background color based on the current color scheme (Dark/Light mode).
    // Returns a deep black for dark mode and a soft off-white for light mode.
    private var backgroundColor: Color {
        colorScheme == .dark ? Color.black : Color(red: 0.925, green: 0.941, blue: 0.953)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Custom Neumorphic Header
                    HStack {
                        Text("Car Service Survey")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.primary.opacity(0.7))
                            .shadow(color: .white, radius: 1, x: -1, y: -1)
                            .shadow(color: .black.opacity(0.15), radius: 1, x: 1, y: 1)
                        Spacer()
                    }
                    .padding()
                    .background(backgroundColor)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 5)
                    .zIndex(1)

                ScrollView {
                    VStack(spacing: 20) {
                        
                        // Personal Info Section
                        GlassSection(title: "Personal Details") {
                            VStack(spacing: 16) {
                                CustomTextField(icon: "person.fill", placeholder: "Full Name", text: $viewModel.name)
                                Divider()
                                CustomTextField(icon: "envelope.fill", placeholder: "Email Address", text: $viewModel.email)
                                    .keyboardType(.emailAddress)
                                Divider()
                                CustomTextField(icon: "phone.fill", placeholder: "Phone Number", text: $viewModel.phone)
                                    .keyboardType(.phonePad)
                                Divider()
                                CustomTextField(icon: "car.fill", placeholder: "Car Model", text: $viewModel.carModel)

                                Divider()

                                DatePickerRow(icon: "calendar", title: "Service Date", date: $viewModel.serviceDate)
                            }
                        }
                        
                        // Ratings Section
                        GlassSection(title: "Service Experience") {
                            VStack(spacing: 20) {
                                RatingSlider(title: "Service Quality", value: $viewModel.serviceRating)
                                Divider()
                                RatingSlider(title: "Support Team", value: $viewModel.supportRating)
                                Divider()
                                RatingSlider(title: "Overall Satisfaction", value: $viewModel.satisfactionRating)
                            }
                        }
                        
                        // Spacer for bottom bar
                        Color.clear.frame(height: 100)
                    }
                    .padding()
                }
                .scrollDismissesKeyboard(.interactively) // Helps with keyboard interaction
                }
                
                // Floating Bottom Action Bar
                VStack {
                    Spacer()
                    BottomActionBar(viewModel: viewModel, selectedTab: $selectedTab)
                }
            }
            .toolbar(.hidden) // Hide default navigation bar
            .alert("Survey", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.alertMessage)
            }
            // Success Toast Overlay
            .overlay(alignment: .top) {
                if viewModel.isSuccess {
                    Text(viewModel.successMessage)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .shadow(radius: 5)
                        .padding(.top, 10)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .onChange(of: viewModel.isSuccess) {
                if viewModel.isSuccess {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            viewModel.isSuccess = false
                        }
                    }
                }
            }
            .onChange(of: viewModel.isSuccess) {
                if viewModel.isSuccess {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                }
            }
        }
    }
}

// MARK : - Bottom Action Bar
// A floating action bar displayed at the bottom of the screen.
// Contains actions to Store, Save, Clear, and View history.
struct BottomActionBar: View {
    @ObservedObject var viewModel: SurveyFormViewModel
    @Binding var selectedTab: Int
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 0) {
            ActionButton(icon: "tray.and.arrow.down.fill", label: "Store") {
                viewModel.storeInCache()
            }
            
            Divider().frame(height: 30)
            
            ActionButton(icon: "externaldrive.fill.badge.checkmark", label: "Save DB") {
                viewModel.flushToDatabase()
            }
            
            Divider().frame(height: 30)
            
            ActionButton(icon: "xmark.circle.fill", label: "Clear") {
                withAnimation { viewModel.clearForm() }
            }
            
            Divider().frame(height: 30)
            
            ActionButton(icon: "list.bullet.rectangle.portrait.fill", label: "View") {
                withAnimation { selectedTab = 1 }
            }
            
            Divider().frame(height: 30)
            
            ActionButton(icon: "chart.bar.xaxis", label: "Stats") {
                withAnimation { selectedTab = 2 }
            }
        }
        .padding(.vertical, 12)
        // Base liquid glass material
        .background(.ultraThinMaterial)
        // Subtle tint that adapts to scheme to enhance the glass body
        .background(
            LinearGradient(
                colors: colorScheme == .dark
                ? [Color.white.opacity(0.06), Color.white.opacity(0.02)]
                : [Color.white.opacity(0.35), Color.white.opacity(0.15)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .blur(radius: 10)
        )
        // Rounded shape for the glass bar
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        // Inner stroke to mimic refraction edge
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.8),
                            Color.white.opacity(0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ), lineWidth: 1
                )
        )
        // Gloss highlight on the top edge
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.35), Color.clear],
                        startPoint: .top,
                        endPoint: .center
                    )
                )
                .blendMode(.plusLighter)
                .opacity(colorScheme == .dark ? 0.25 : 0.5)
                .padding(.horizontal, 1)
                .padding(.vertical, 1)
        )
        // Soft shadows for elevation
        .shadow(color: colorScheme == .dark ? Color.black.opacity(0.6) : Color.black.opacity(0.12), radius: 20, x: 0, y: 12)
        .shadow(color: colorScheme == .dark ? Color.white.opacity(0.06) : Color.white.opacity(0.5), radius: 8, x: -1, y: -1)
        // Subtle motion to create a fluid feel
        .sensoryFeedback(.selection, trigger: selectedTab)
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}

// A reusable button component used within the BottomActionBar.
// Provides a consistent look and haptic feedback on tap.
struct ActionButton: View {
    let icon: String
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            action()
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(label)
                    .font(.caption2)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(.primary)
        }
    }
}

// MARK : - Reusable UI Components

// A container view that applies a glass-morphism or neumorphic style
// depending on the color scheme. Used to group form sections.
struct GlassSection<Content: View>: View {
    let title: String
    let content: Content
    @Environment(\.colorScheme) var colorScheme
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title.uppercased())
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(.leading, 4)
            
            VStack {
                content
            }
            .padding()
            .background(colorScheme == .dark ? Color(red: 0.23, green: 0.23, blue: 0.25) : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: colorScheme == .dark ? Color.black.opacity(0.3) : Color.black.opacity(0.05), radius: 10, x: 5, y: 5)
            .shadow(color: colorScheme == .dark ? Color.white.opacity(0.05) : Color.white, radius: 10, x: -5, y: -5)
        }
    }
}

// A custom text field row with an icon and placeholder.
struct CustomTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
                .frame(width: 24)
            
            TextField(placeholder, text: $text)
        }
    }
}

// A custom row containing an icon, label, and a date picker.
struct DatePickerRow: View {
    let icon: String
    let title: String
    @Binding var date: Date
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
                .frame(width: 24)
            Text(title)
            Spacer()
            
            DatePicker("", selection: $date, in:...Date(), displayedComponents: .date)
                .labelsHidden()
        }
    }
}

// A custom slider component for selecting a rating from 1 to 5.
struct RatingSlider: View {
    let title: String
    @Binding var value: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.subheadline)
                Spacer()
                Text(String(format: "%.1f/5", value))
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
            }
            
            Slider(value: $value, in: 1...5, step: 0.5) {
                Text("Rating")
            } minimumValueLabel: {
                Image(systemName: "star")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            } maximumValueLabel: {
                Image(systemName: "star.fill")
                    .font(.caption2)
                    .foregroundColor(.accentColor)
            }
        }
    }
}
