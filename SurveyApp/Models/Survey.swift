//
//  Survey.swift
//  SurveyApp
//
//  Created by Nettem Taraka Ram Teja on 23/02/26.
//

import Foundation

// The domain model representing a completed survey.
// Conforms to Identifiable, Codable, and Equatable for usage in Lists, Queues, and persistence.
struct Survey: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let email: String
    let phone: String
    let carModel: String
    let serviceDate: Date
    
    let serviceRating: Double
    let supportRating: Double
    let satisfactionRating: Double
    
    let createdAt: Date
}
