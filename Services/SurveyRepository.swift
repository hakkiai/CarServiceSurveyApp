//
//  SurveyRepository.swift
//  SurveyApp
//
//  Created by Nettem Taraka Ram Teja on 23/02/26.
//

import Foundation
import CoreData

/// Protocol defining the contract for survey data operations.
protocol SurveyRepositoryProtocol {
    func enqueueSurvey(_ survey: Survey)
    func flushSurveys() async throws -> Int
    func fetchAll() async throws -> [Survey]
}

/// The concrete implementation of the data repository.
/// It coordinates between the in-memory CacheService and the Core Data PersistenceController.
class SurveyRepository: SurveyRepositoryProtocol {
    private let persistenceController = PersistenceController.shared
    private let cacheService = CacheService()
    
    /// Adds a survey to the temporary cache.
    func enqueueSurvey(_ survey: Survey) {
        cacheService.enqueue(survey)
        print("📥 Survey Enqueued. Cache Size: \(cacheService.count)")
    }
    
    /// Moves all surveys from the cache to the Core Data persistent store.
    /// - Returns: The number of surveys successfully saved.
    func flushSurveys() async throws -> Int {
        let surveys = cacheService.dequeueAll()
        guard !surveys.isEmpty else { return 0 }
        
        let context = persistenceController.container.viewContext
        
        // Perform the save on the context's queue
        try await context.perform {
            for survey in surveys {
                let entity = SurveyEntity(context: context)
                entity.id = survey.id
                entity.name = survey.name
                entity.email = survey.email
                entity.phone = survey.phone
                entity.carModel = survey.carModel
                entity.serviceDate = survey.serviceDate
                entity.serviceRating = (survey.serviceRating)
                entity.supportRating = (survey.supportRating)
                entity.satisfactionRating = (survey.satisfactionRating)
                entity.createdAt = survey.createdAt
            }
            
            try context.save()
        }
        
        print("✅ Flushed \(surveys.count) surveys to Core Data")
        return surveys.count
    }
    
    /// Fetches all surveys from the persistent store.
    /// (Currently unused by UI which relies on @FetchRequest).
    func fetchAll() async throws -> [Survey] {
        // Note: The UI uses @FetchRequest for live updates, but this is here for protocol completeness
        return []
    }
}
