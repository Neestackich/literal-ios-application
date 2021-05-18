//
//  MockLoginRouter.swift
//  iTechBookTests
//
//  Created by Neestackich on 11.02.21.
//

@testable import iTechBook
import RxSwift

final class MockLoginRouter: LoginRouterType {
    var showLibraryScreenCalled = false
    var showWelcomeScreenCalled = false
    private let errorMessage = "Test error message"
    private let errorTitle = "Test error title"
    private let showScreenReturnValue = Single<Void>.never()

    func showLibraryScreen() -> Single<Void> {
        showLibraryScreenCalled = true
        return showScreenReturnValue
    }

    func showWelcomeScreen() -> Single<Void> {
        showWelcomeScreenCalled = true
        return showScreenReturnValue
    }

    func showError(title: String, message: String) {}

    func showError(_ error: Error) {}
}
