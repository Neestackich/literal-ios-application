//
//  LoginScreenUITest.swift
//  iTechBookUITests
//
//  Created by Neestackich on 19.02.21.
//

@testable import iTechBook
import XCTest

final class LoginScreenUITest: XCTestCase {
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

    func testSuccessfulLogin() {
        app.textFields["loginScreenEmailTextField"].tap()
        app.textFields["loginScreenEmailTextField"].typeText("qwerty@mail.ru")
        app/*@START_MENU_TOKEN@*/.secureTextFields["loginScreenPasswordTextfield"]/*[[".secureTextFields[\"пароль\"]",".secureTextFields[\"loginScreenPasswordTextfield\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.secureTextFields["loginScreenPasswordTextfield"]/*[[".secureTextFields[\"пароль\"]",".secureTextFields[\"loginScreenPasswordTextfield\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.typeText("qwertyqwerty")
        app/*@START_MENU_TOKEN@*/.buttons["loginScrenLoginButton"]/*[[".buttons[\"Логин\"]",".buttons[\"loginScrenLoginButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }

    func testFailLogin() {
        app/*@START_MENU_TOKEN@*/.textFields["loginScreenEmailTextField"]/*[[".textFields[\"имейл\"]",".textFields[\"loginScreenEmailTextField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.textFields["loginScreenEmailTextField"]/*[[".textFields[\"имейл\"]",".textFields[\"loginScreenEmailTextField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.typeText("qwerty@mail.ru")
        app/*@START_MENU_TOKEN@*/.secureTextFields["loginScreenPasswordTextfield"]/*[[".secureTextFields[\"пароль\"]",".secureTextFields[\"loginScreenPasswordTextfield\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.secureTextFields["loginScreenPasswordTextfield"]/*[[".secureTextFields[\"пароль\"]",".secureTextFields[\"loginScreenPasswordTextfield\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.typeText("qwertyqwert")
        app/*@START_MENU_TOKEN@*/.buttons["loginScrenLoginButton"]/*[[".buttons[\"Логин\"]",".buttons[\"loginScrenLoginButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts["errorAlert"].scrollViews.otherElements.buttons["Ок"].tap()
    }

    func testBackButton() {
        app.buttons["loginScreenBackButton"].tap()
        app.buttons["welocomeScreenLoginButton"].tap()
    }
}
