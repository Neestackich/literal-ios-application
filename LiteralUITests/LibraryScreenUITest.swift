//
//  LibraryScreenUITest.swift
//  iTechBookUITests
//
//  Created by Neestackich on 19.02.21.
//

@testable import iTechBook
import XCTest

final class LibraryScreenUITest: XCTestCase {
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

    func testTabBarItemsSelection() {
        let tabBar = app.tabBars["tabBarController"]
        let accountButton = tabBar.buttons["accountTabBarItem"]
        let libraryButton = tabBar.buttons["libraryTabBarItem"]

        accountButton.tap()
        libraryButton.tap()
    }

    func testSuccessfullBookAdding() {
        app.buttons["libraryAddButton"].tap()
        app.textFields["addBookScreenNameTextField"].tap()
        app.textFields["addBookScreenNameTextField"].typeText("book name")
        app.textFields["addBookScreenAuthorTextField"].tap()
        app.textFields["addBookScreenAuthorTextField"].typeText("book author")
        app.buttons["addBookScreenDoneButton"].tap()
    }

    func testCellSelection() {
        app.tables["libraryTableView"].cells.firstMatch.tap()
        app.buttons["bookScreenBackButton"].tap()
    }

    func testTableViewScroll() {
        app.tables["LibraryTableView"].accessibilityScroll(.down)
        app.tables["LibraryTableView"].accessibilityScroll(.up)
    }
}
