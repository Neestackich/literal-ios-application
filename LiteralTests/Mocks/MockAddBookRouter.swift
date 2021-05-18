//
//  MockAddBookRouter.swift
//  iTechBookTests
//
//  Created by Neestackich on 14.02.21.
//

@testable import iTechBook

final class MockAddBookRouter: AddBookRouterType {
    var backToLibraryCalled = false
    private let errorTitle = "FakeError"
    private let errorMessage = "FakeError"

    func backToLibrary() {
        backToLibraryCalled = true
    }

    func showError(title: String, message: String) {}

    func showError(_ error: Error) {}
}
