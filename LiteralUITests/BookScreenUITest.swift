//
//  BookScreenUITest.swift
//  iTechBookUITests
//
//  Created by Neestackich on 19.02.21.
//

@testable import iTechBook
import XCTest

final class BookScreenUITest: XCTestCase {
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

    func testBackButton() {
        app.tables["libraryTableView"].cells.firstMatch.tap()
        app.buttons["bookScreenBackButton"].tap()
    }

    func testSwipeDown() {
        app.tables["libraryTableView"].cells.firstMatch.tap()
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
