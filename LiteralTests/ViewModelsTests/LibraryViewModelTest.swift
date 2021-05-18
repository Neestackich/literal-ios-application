//
//  LibraryViewModelTest.swift
//  iTechBookTests
//
//  Created by Neestackich on 13.02.21.
//

@testable import iTechBook
import XCTest
import RxSwift
import RxTest

final class LibraryViewModelTest: XCTestCase {
    private var sut: LibraryViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!

    private let mockAPIClient = MockAPIClient()
    private let mockRouter = MockLibraryRouter()
    private let mockBookStorage = MockCoreDataBookStorage()
    private let mockCredentialsStore = MockKeychainCredentialsStore()

    private let cellSelectionInput = PublishSubject<Book>()
    private let addButtonInput = PublishSubject<Void>()

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        sut = LibraryViewModel(
            apiClient: mockAPIClient,
            router: mockRouter,
            credentialsStore: mockCredentialsStore,
            database: mockBookStorage)

        let output = sut.transform(input: LibraryViewModelInput(
                                    addBookButton: addButtonInput
                                        .asDriver(onErrorDriveWith: .empty()),
                                    cellSelection: cellSelectionInput
                                        .asDriver(onErrorDriveWith: .empty())))

        disposeBag.insert(output.triggers.drive(),
                          output.books.drive(),
                          output.mineBooksQuantity.drive(),
                          output.booksQuantity.drive(),
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

    func testCredentialsRequested() {
        XCTAssertTrue(mockCredentialsStore.credentialsRequested)
    }

    func testGetAllDatabaseBooksCalled() {
        XCTAssertTrue(mockBookStorage.getAllBooksCalled)
    }

    func testSaveBooksCalled() {
        XCTAssertTrue(mockBookStorage.saveBooksCalled)
    }

    func testAddButtonClicked() {
        scheduler
            .createColdObservable([.next(1, ())])
            .bind(to: addButtonInput)
            .disposed(by: disposeBag)
        scheduler.start()

        XCTAssertTrue(mockRouter.showAddBookScreenCalled)
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
