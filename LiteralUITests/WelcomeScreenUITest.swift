//
//  iTechBookUITests.swift
//  iTechBookUITests
//
//  Created by Neestackich on 19.02.21.
//

@testable import iTechBook
import XCTest

final class WelcomeScreenUITest: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        continueAfterFailure = false
        app.launchArguments.append("--UITesting")
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func testLoginButton() {
        app.buttons["welocomeScreenLoginButton"].tap()
        app.buttons["loginScreenBackButton"].tap()
    }

    func testCreateAccountButton() {
        app.buttons["welocomeScreenCreateButton"].tap()
        app.buttons["createAccountBackButton"].tap()
    }
}
