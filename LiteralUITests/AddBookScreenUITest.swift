//
//  AddBookScreenUITest.swift
//  iTechBookUITests
//
//  Created by Neestackich on 19.02.21.
//

@testable import iTechBook
import XCTest

final class AddBookScreenUITest: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        continueAfterFailure = false
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func testSuccessfulBookAddition() {
        app.buttons["libraryAddButton"].tap()
        app.textFields["addBookScreenNameTextField"].tap()
        app.textFields["addBookScreenNameTextField"].typeText("book name")
        app.textFields["addBookScreenAuthorTextField"].tap()
        app.textFields["addBookScreenAuthorTextField"].typeText("book author")
        app.buttons["addBookScreenDoneButton"].tap()
    }

    func testBackButton() {
        app.buttons["libraryAddButton"].tap()
        app.buttons["addBookScreenBackButton"].tap()
    }

    func testSwipeDownAddBookScreen() {
        app.buttons["libraryAddButton"].tap()
        app.windows.children(matching: .other)
            .element(boundBy: 1)
            .children(matching: .other)
            .element(boundBy: 1)
            .children(matching: .other)
            .element.children(matching: .other)
            .element.children(matching: .other)
            .element.children(matching: .other)
            .element(boundBy: 0)
            .swipeDown()
    }
}
