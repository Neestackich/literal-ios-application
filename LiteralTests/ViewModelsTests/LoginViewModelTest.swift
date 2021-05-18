//
//  LoginViewModelTest.swift
//  iTechBookTests
//
//  Created by Neestackich on 10.02.21.
//

@testable import iTechBook
import XCTest
import RxSwift
import RxTest

final class LoginViewModelTest: XCTestCase {
    private var sut: LoginViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!

    private let mockAPIClient = MockAPIClient()
    private let mockValidator = MockCredentialsValidator()
    private let mockRouter = MockLoginRouter()
    private let mockCredentialsStore = MockKeychainCredentialsStore()

    private let loginButtonInput = PublishSubject<Void>()
    private let backButtonInput = PublishSubject<Void>()
    private let emailTextfieldInput = PublishSubject<String?>()
    private let passwordTextfieldInput = PublishSubject<String?>()
    private let viewTapInput = PublishSubject<UITapGestureRecognizer>()
    private let keyboardNotifications = PublishSubject<Notification>()

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        sut = LoginViewModel(
            apiClient: mockAPIClient,
            validator: mockValidator,
            router: mockRouter,
            credentialsStore: mockCredentialsStore)

        let output = sut.transform(input:
            LoginViewModelInput(mail: emailTextfieldInput
                                    .asDriver(onErrorDriveWith: .empty()),
                                password: passwordTextfieldInput
                                    .asDriver(onErrorDriveWith: .empty()),
                                loginButtonClick: loginButtonInput
                                    .asDriver(onErrorDriveWith: .empty()),
                                backButtonClick: backButtonInput
                                    .asDriver(onErrorDriveWith: .empty()),
                                    viewTap: viewTapInput.asDriver(onErrorDriveWith: .empty()),
                                keyboardNotifications: keyboardNotifications.asDriver(onErrorDriveWith: .empty())))

        disposeBag.insert(output.triggers.drive(),
        output.isLoading.drive(),
        output.buttonIsEnabled.drive(),
        output.areUIElementsHidden.drive())
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

        XCTAssertTrue(mockRouter.showWelcomeScreenCalled)
    }

    func testCredentialsValidationCalled() {
        scheduler
            .createColdObservable([.next(0, "qwertyqwerty")])
            .bind(to: passwordTextfieldInput)
            .disposed(by: disposeBag)
        scheduler
            .createColdObservable([.next(0, "qwerty@mail.ru")])
            .bind(to: emailTextfieldInput)
            .disposed(by: disposeBag)
        scheduler.start()

        XCTAssertTrue(mockValidator.credentialsValidationCalled)
    }

    func testSuccessfullLogin() {
        scheduler
            .createColdObservable([.next(0, "qwertyqwerty")])
            .bind(to: passwordTextfieldInput)
            .disposed(by: disposeBag)
        scheduler
            .createColdObservable([.next(0, "qwerty@mail.ru")])
            .bind(to: emailTextfieldInput)
            .disposed(by: disposeBag)
        scheduler
            .createColdObservable([.next(0, ())])
            .bind(to: loginButtonInput)
            .disposed(by: disposeBag)
        scheduler.start()

        XCTAssertTrue(mockAPIClient.requestCalled)
    }

    func testCredentialsAreSaved() {
        scheduler
            .createColdObservable([.next(0, "qwertyqwerty")])
            .bind(to: passwordTextfieldInput)
            .disposed(by: disposeBag)
        scheduler
            .createColdObservable([.next(0, "qwerty@mail.ru")])
            .bind(to: emailTextfieldInput)
            .disposed(by: disposeBag)
        scheduler
            .createColdObservable([.next(0, ())])
            .bind(to: loginButtonInput)
            .disposed(by: disposeBag)
        scheduler.start()

        XCTAssertTrue(mockCredentialsStore.credentialsSetted)
    }
}
