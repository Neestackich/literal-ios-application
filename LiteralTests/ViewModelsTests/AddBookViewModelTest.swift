//
//  AddBookViewModelTest.swift
//  iTechBookTests
//
//  Created by Neestackich on 13.02.21.
//

@testable import iTechBook
import XCTest
import RxSwift
import RxTest

final class AddBookViewModelTest: XCTestCase {
    private var sut: AddBookViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!

    private let mockAPIClient = MockAPIClient()
    private let mockRouter = MockAddBookRouter()

    private let doneButtonInput = PublishSubject<Void>()
    private let backButtonInput = PublishSubject<Void>()
    private let nameTextfieldInput = PublishSubject<String?>()
    private let authorTextfieldInput = PublishSubject<String?>()

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        sut = AddBookViewModel(apiClient: mockAPIClient,
                               router: mockRouter)

        let output = sut.transform(input: AddBookViewModelInput(
                                    doneClick: doneButtonInput
                                        .asDriver(onErrorDriveWith: .empty()),
                                    backClick: backButtonInput
                                        .asDriver(onErrorDriveWith: .empty()),
                                    nameTextField: nameTextfieldInput
                                        .asDriver(onErrorDriveWith: .empty()),
                                    authorTextField: authorTextfieldInput
                                        .asDriver(onErrorDriveWith: .empty())))

        disposeBag.insert(output.triggers.drive(),
                          output.isLoading.drive(),
                          output.isValidName.drive())
    }

    override func tearDown() {
        sut = nil
        disposeBag = nil
        scheduler = nil
        super.tearDown()
    }

    func testBackButtonClicked() {
        scheduler
            .createColdObservable([.next(1, ())])
            .bind(to: backButtonInput)
            .disposed(by: disposeBag)
        scheduler.start()

        XCTAssertTrue(mockRouter.backToLibraryCalled)
    }

    func testSuccessfullBookAddition() {
        scheduler
            .createColdObservable([.next(0, "FakeName")])
            .bind(to: nameTextfieldInput)
            .disposed(by: disposeBag)
        scheduler
            .createColdObservable([.next(0, "FakeAuthor")])
            .bind(to: authorTextfieldInput)
            .disposed(by: disposeBag)
        scheduler
            .createColdObservable([.next(1, ())])
            .bind(to: doneButtonInput)
            .disposed(by: disposeBag)
        scheduler.start()

        XCTAssertTrue(mockAPIClient.requestCalled)
    }
}
