//
//  AccountViewModelTest.swift
//  iTechBookTests
//
//  Created by Neestackich on 13.02.21.
//

@testable import iTechBook
import XCTest
import RxSwift
import RxTest

final class AccountViewModelTest: XCTestCase {
    private var sut: AccountViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!

    private let mockAPIClient = MockAPIClient()
    private let mockRouter = MockAccountRouter()
    private let mockBookStorage = MockCoreDataBookStorage()
    private let mockCredentialsStore = MockKeychainCredentialsStore()

    private let cellSelectionInput = PublishSubject<Book>()
    private let logoutButtonInput = PublishSubject<Void>()

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        sut = AccountViewModel(
            apiClient: mockAPIClient,
            router: mockRouter,
            credentialsStore: mockCredentialsStore,
            database: mockBookStorage)

        let output = sut.transform(input: AccountViewModelInput(
                                    logOutClick: logoutButtonInput
                                        .asDriver(onErrorDriveWith: .never()),
                                    cellSelection: cellSelectionInput
                                        .asDriver(onErrorDriveWith: .never())))

        disposeBag.insert(output.triggers.drive(),
                          output.books.drive(),
                          output.email.drive(),
                          output.isDataEmpty.drive())
    }

    override func tearDown() {
        sut = nil
        disposeBag = nil
        scheduler = nil
        super.tearDown()
    }

    func testRequestCalledSuccessfully() {
        XCTAssertTrue(mockAPIClient.requestCalled)
    }

    func testGetMyBooksCalled() {
        XCTAssertTrue(mockBookStorage.getMyBooksCalled)
    }

    func testGetUserCredentialsFromKeychainCalled() {
        XCTAssertTrue(mockCredentialsStore.credentialsRequested)
    }

    func testLogotButtonClicked() {
        scheduler
            .createColdObservable([.next(1, ())])
            .bind(to: logoutButtonInput)
            .disposed(by: disposeBag)
        scheduler.start()

        XCTAssertTrue(mockRouter.showWelcomeScreenCalled)
    }

    func testCredentialsSettedToNil() {
        scheduler
            .createColdObservable([.next(1, ())])
            .bind(to: logoutButtonInput)
            .disposed(by: disposeBag)
        scheduler.start()

        XCTAssertTrue(mockCredentialsStore.credentialsSetted)
    }

    func testCellSelected() {
        let fakeBook =  Book(
            id: 0,
            name: "Fake book",
            ownerId: 0,
            createdAt: Date(),
            updatedAt: Date(),
            status: .inLibrary,
            deadLine: nil,
            readerUserId: nil)

        scheduler
            .createColdObservable([.next(0, fakeBook)])
            .bind(to: cellSelectionInput)
            .disposed(by: disposeBag)
        scheduler.start()

        XCTAssertTrue(mockRouter.showBookScreenCalled)
    }
}
