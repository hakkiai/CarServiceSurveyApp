//
//  SurveyAppUITests.swift
//  SurveyAppUITests
//
//  Created by Nettem Taraka Ram Teja on 27/02/26.
//



import XCTest

final class SurveyAppUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testAppLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertTrue(app.exists)
    }
}
