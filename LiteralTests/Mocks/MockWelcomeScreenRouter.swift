//
//  MockWelcomScreenRouter.swift
//  iTechBookTests
//
//  Created by Neestackich on 14.02.21.
//

@testable import iTechBook
import RxSwift

final class MockWelcomScreenRouter: WelcomeScreenRouterType {
    var showLoginScreenCalled = false
    var showCreateAccountScreenCalled = false
    private let errorMessage = "Test error message"
    private let errorTitle = "Test error title"
    private let showScreenReturnValue = Single<Void>.never()

    func showLoginScreen() -> Single<Void> {
        showLoginScreenCalled = true
        return showScreenReturnValue
    }

    func showCreateAccountScreen() -> Single<Void> {
        showCreateAccountScreenCalled = true
        return showScreenReturnValue
    }

    func showError(title: String, message: String) {}

    func showError(_ error: Error) {}
}
