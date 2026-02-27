//
//  SurveyAppUITestsLaunchTests.swift
//  SurveyAppUITests
//
//  Created by Nettem Taraka Ram Teja on 27/02/26.
//

//
//  SurveyAppUITestsLaunchTests.swift
//  SurveyAppUITests
//

import XCTest

final class SurveyAppUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
