//
//  SurveyAppTests.swift
//  SurveyAppTests
//
//  Created by Nettem Taraka Ram Teja on 27/02/26.
//

//
//  SurveyAppTests.swift
//  SurveyAppTests
//

import XCTest
@testable import SurveyApp

class MockSurveyRepository: SurveyRepositoryProtocol {
    func enqueueSurvey(_ survey: Survey) {}
    func flushSurveys() async throws -> Int { return 0 }
    func fetchAll() async throws -> [Survey] { return [] }
}

final class SurveyAppTests: XCTestCase {

    func testValidationFailsForInvalidEmail() async {
        await MainActor.run {
            let repository = MockSurveyRepository()
            let viewModel = SurveyFormViewModel(repository: repository)

            viewModel.name = "John"
            viewModel.email = "invalidEmail"
            viewModel.phone = "1234567890"
            viewModel.carModel = "BMW"

            XCTAssertFalse(viewModel.validate())
        }
    }

    func testValidationSucceedsForValidInput() async {
        await MainActor.run {
            let repository = MockSurveyRepository()
            let viewModel = SurveyFormViewModel(repository: repository)

            viewModel.name = "John"
            viewModel.email = "john@email.com"
            viewModel.phone = "1234567890"
            viewModel.carModel = "BMW"

            XCTAssertTrue(viewModel.validate())
        }
    }
}
