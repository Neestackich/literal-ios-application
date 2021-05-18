//
//  WelcomeScreenViewModelTest.swift
//  iTechBookTests
//
//  Created by Neestackich on 13.02.21.
//

@testable import iTechBook
import XCTest
import RxSwift
import RxTest

final class WelcomeScreenViewModelTest: XCTestCase {
    private var sut: WelcomeScreenViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!

    private let mockRouter = MockWelcomScreenRouter()

    private let loginButtonInput = PublishSubject<Void>()
    private let createButtonInput = PublishSubject<Void>()

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        sut = WelcomeScreenViewModel(router: mockRouter)

        let output = sut.transform(input: WelcomeScreenViewModelInput(
                                    loginButtonClick: loginButtonInput
                                        .asDriver(onErrorDriveWith: .empty()),
                                    createAccountButtonClick: createButtonInput
                                        .asDriver(onErrorDriveWith: .empty())))

        disposeBag.insert(output.triggers.drive())
    }

    override func tearDown() {
        disposeBag = nil
        scheduler = nil
        sut = nil
        super.tearDown()
    }

    func testLoginButtonClicked() {
        scheduler
            .createColdObservable([.next(1, ())])
            .bind(to: loginButtonInput)
            .disposed(by: disposeBag)
        scheduler.start()

        XCTAssertTrue(mockRouter.showLoginScreenCalled)
    }

    func testCreateAccountButtonClicked() {
        scheduler
            .createColdObservable([.next(1, ())])
            .bind(to: createButtonInput)
            .disposed(by: disposeBag)
        scheduler.start()

        XCTAssertTrue(mockRouter.showCreateAccountScreenCalled)
    }
}
