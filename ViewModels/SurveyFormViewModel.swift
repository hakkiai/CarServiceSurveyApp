//
//  SurveyFormViewModel.swift
//  SurveyApp
//
//  Created by Abhishek Tripathi Kuberji on 23/02/26.
//

import SwiftUI
import Combine

// The ViewModel for the SurveyFormView.
// It manages the state of the form fields, handles validation logic,
// and communicates with the repository to store data.
@MainActor
class SurveyFormViewModel: ObservableObject {
    
    // MARK : - Form Fields
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var carModel: String = ""
    @Published var serviceDate: Date = Date()
    
    @Published var serviceRating: Double = 0
    @Published var supportRating: Double = 0
    @Published var satisfactionRating: Double = 0
    
    // MARK : UI STATE
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var isSuccess: Bool = false
    @Published var successMessage: String = ""
    
    
    // MARK : - Dependencies
    private let repository: SurveyRepositoryProtocol
    
    // Initializes the ViewModel with a repository instance.
    init(repository: SurveyRepositoryProtocol) {
        self.repository = repository
    }
    
    //MARK: VALIDATION
    // Validates the form inputs (Name, Email, Phone).
    // Updates alertMessage and returns false if validation fails.
    func validate() -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedPhone = phone.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Name validation (letters + spaces only)
            let nameRegex = "^[A-Za-z ]+$"
            if trimmedName.isEmpty || trimmedName.range(of: nameRegex, options: .regularExpression) == nil {
                alertMessage = "Name should contain only letters."
                return false
            }
            
            // Email validation
            let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
            if trimmedEmail.range(of: emailRegex, options: .regularExpression) == nil {
                alertMessage = "Please enter a valid email address."
                return false
            }
            
            // Phone validation (10 digits only)
            let phoneRegex = "^[0-9]{10}$"
            if trimmedPhone.range(of: phoneRegex, options: .regularExpression) == nil {
                alertMessage = "Phone number must be 10 digits."
                return false
            }
        
        // Car Model validation
            let trimmedCarModel = carModel.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedCarModel.isEmpty {
                alertMessage = "Please enter your car model."
                return false
        }
            
            return true
        }
    
    //MARK : ACTIONS
    // Validates the form and stores the survey in the temporary cache.
    // Triggers UI updates for success or failure.
    func storeInCache() {
        isSuccess = false
        if !validate() {
            showAlert = true
            return
        }
        
        isLoading = true
        
        let survey = Survey(
            id: UUID(),
            name: name,
            email: email,
            phone: phone,
            carModel: carModel,
            serviceDate: serviceDate,
            serviceRating: (serviceRating),
            supportRating: (supportRating),
            satisfactionRating: (satisfactionRating),
            createdAt: Date()
        )
        
        repository.enqueueSurvey(survey)
        
        isLoading = false
        isSuccess = true
        successMessage = "Survey Stored in Cache"
        clearForm()
    }
    
    // Flushes all cached surveys to the persistent Core Data storage.
    // Updates UI based on the result of the operation.
    func flushToDatabase() {
        isLoading = true
        
        Task {
            do {
                let count = try await repository.flushSurveys()
                isLoading = false
                if count > 0 {
                    successMessage = "Saved \(count) surveys to DB"
                    isSuccess = true
                }
            } catch {
                isLoading = false
                alertMessage = "Failed to save: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }
    
    // Resets all form fields to their default values.
    func clearForm() {
        name = ""
        email = ""
        phone = ""
        carModel = ""
        serviceDate = Date()
        serviceRating = 0
        supportRating = 0
        satisfactionRating = 0
    }
}
