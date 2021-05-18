//
//  BookScreenViewModelTest.swift
//  iTechBookTests
//
//  Created by Neestackich on 13.02.21.
//

@testable import iTechBook
import XCTest
import RxSwift
import RxCocoa
import RxTest

final class BookScreenViewModelTest: XCTestCase {
    private var sut: BookScreenViewModel! = nil
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!

    private let mockRouter = MockBookScreenRouter()

    private let fakeControllEvent = ControlEvent(events: PublishSubject<Bool>())
    private let backButtonInput = PublishSubject<Void>()
    private let fakeBook = Book(id: 0,
                                name: "FakeName",
                                ownerId: 0,
                                createdAt: Date(),
                                updatedAt: Date(),
                                status: .inLibrary,
                                deadLine: nil,
                                readerUserId: nil)

    override func setUp() {
        super.setUp()
        sut = BookScreenViewModel(
            router: mockRouter,
            book: fakeBook)
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()

        let output = sut.transform(input: BookScreenViewModelInput(
                                    backClick: backButtonInput
                                        .asDriver(onErrorDriveWith: .empty()),
                                    refreshTrigger: fakeControllEvent))
        disposeBag.insert(output.triggers.drive())
    }

    override func tearDown() {
        sut = nil
        scheduler = nil
        disposeBag = nil
        super.tearDown()
    }

    func testBackButtonClicked() {
        scheduler
            .createColdObservable([.next(1, ())])
            .bind(to: backButtonInput)
            .disposed(by: disposeBag)
        scheduler.start()

        XCTAssertTrue(mockRouter.showLibraryScreenCalled)
    }
}
