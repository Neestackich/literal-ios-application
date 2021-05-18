//
//  AccountScreenUITest.swift
//  iTechBookUITests
//
//  Created by Neestackich on 19.02.21.
//

@testable import iTechBook
import XCTest

final class AccountScreenUITest: XCTestCase {
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

    func testCellSelection() {
        let tabBar = app.tabBars["tabBarController"]
        let accountButton = tabBar.buttons["accountTabBarItem"]
        accountButton.tap()
        app.tables["accountTableView"].cells.firstMatch.tap()
        app.buttons["bookScreenBackButton"].tap()
    }

    func testTableViewScroll() {
        let tabBar = app.tabBars["tabBarController"]
        let accountButton = tabBar.buttons["accountTabBarItem"]
        accountButton.tap()
        app.tables["accountTableView"].accessibilityScroll(.down)
        app.tables["accountTableView"].accessibilityScroll(.up)
    }

    func testLogOutButton() {
        let tabBar = app.tabBars["tabBarController"]
        let accountButton = tabBar.buttons["accountTabBarItem"]
        accountButton.tap()

        app.buttons["logOutButton"].tap()
    }
}
