//
//  MockAccountRouter.swift
//  iTechBookTests
//
//  Created by Neestackich on 15.02.21.
//

@testable import iTechBook
import RxSwift

final class MockAccountRouter: AccountRouterType {
    var showWelcomeScreenCalled = false
    var showBookScreenCalled = false
    private let showScreenReturnValue = Single<Void>.never()

    func showWelcomeScreen() {
        showWelcomeScreenCalled = true
    }

    func showBookScreen(book: Book) -> Single<Void> {
        showBookScreenCalled = true
        return showScreenReturnValue
    }

    func showError(title: String, message: String) {}

    func showError(_ error: Error) {}
}
