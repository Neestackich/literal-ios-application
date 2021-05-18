//
//  MockLibraryRouter.swift
//  iTechBookTests
//
//  Created by Neestackich on 15.02.21.
//

@testable import iTechBook
import RxSwift

final class MockLibraryRouter: LibraryRouterType {
    var showAddBookScreenCalled = false
    var showBookScreenCalled = false
    private let showScreenReturnValue = Single<Void>.never()

    func showAddBookScreen() -> Single<Void> {
        showAddBookScreenCalled = true
        return showScreenReturnValue
    }

    func showBookScreen(book: Book) -> Single<Void> {
        showBookScreenCalled = true
        return showScreenReturnValue
    }

    func showError(title: String, message: String) {}

    func showError(_ error: Error) {}
}
