//
//  MockBookScreenRouter.swift
//  iTechBookTests
//
//  Created by Neestackich on 14.02.21.
//

@testable import iTechBook
import RxSwift

final class MockBookScreenRouter: BookScreenRouterType {
    var showLibraryScreenCalled = false
    private let showScreenReturnValue = Single<Void>.never()

    func showLibraryScreen() -> Single<Void> {
        showLibraryScreenCalled = true
        return showScreenReturnValue
    }
}
