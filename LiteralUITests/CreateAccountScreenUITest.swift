//
//  CreateAccountScreenUITest.swift
//  iTechBookUITests
//
//  Created by Neestackich on 19.02.21.
//

@testable import iTechBook
import XCTest

final class CreateAccountScreenUITest: XCTestCase {
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

    func testSuccessfulCreateAccount() {
        app.textFields["createAccountEmailTextField"].tap()
        app.textFields["createAccountEmailTextField"].typeText("fakeUuser999@mail.ru")
        app.secureTextFields["createAccountPasswordTextfield"].tap()
        app.secureTextFields["createAccountPasswordTextfield"].typeText("qwertyqwerty")
        app.secureTextFields["createAccountConfirmPasswordTextfield"].tap()
        app.secureTextFields["createAccountConfirmPasswordTextfield"].typeText("qwertyqwerty")
        app.buttons["createAccountCreateButton"].tap()
    }

    func testFailCreateAccount() {
        app.textFields["createAccountEmailTextField"].tap()
        app.textFields["createAccountEmailTextField"].typeText("qwerty@mail.ru")
        app.secureTextFields["createAccountPasswordTextfield"].tap()
        app.secureTextFields["createAccountPasswordTextfield"].typeText("qwertyqwerty")
        app.secureTextFields["createAccountConfirmPasswordTextfield"].tap()
        app.secureTextFields["createAccountConfirmPasswordTextfield"].typeText("qwertyqwerty")
        app.buttons["createAccountCreateButton"].tap()
        app.alerts["errorAlert"].scrollViews.otherElements.buttons["Ок"].tap()
    }

    func testBackButton() {
        app.buttons["createAccountBackButton"].tap()
        app.buttons["welocomeScreenCreateButton"].tap()
    }
}
