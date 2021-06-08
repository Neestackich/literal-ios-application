//
//  CreateAccountViewModel.swift
//  Literal
//
//  Created by Neestackich on 24.11.20.
//

import UIKit
import RxSwift
import RxCocoa

struct CreateAccountViewModelInput {
    let mail: Driver<String?>
    let username: Driver<String?>
    let password: Driver<String?>
    let passwordConfirm: Driver<String?>
    let createButtonClick: Driver<Void>
    let backButtonClick: Driver<Void>
    let viewTap: Driver<UITapGestureRecognizer>
    let keyboardNotifications: Driver<Notification>
}

struct CreateAccountViewModelOutput {
    let areCredentialsValid: Driver<Bool>
    let triggers: Driver<Void>
    let isLoading: Driver<Bool>
    let areUIElementsHidden: Driver<Bool>
    let buttonIsEnabled: Driver<Bool>
    let isPasswordConfirmed: Driver<Bool>
    let hideKeyboard: Driver<Bool>
    let transformView: Driver<Notification>
}

protocol CreateAccountViewModelType {
    func transform(input: CreateAccountViewModelInput) -> CreateAccountViewModelOutput
}

final class CreateAccountViewModel: CreateAccountViewModelType {

    // MARK: - Properties

    private let apiClient: APIClientType
    private let validator: CredentialsValidatorType
    private let router: LoginRouterType
    private var credentialsStore: CredentialsStore

    // MARK: - Methods

    init(apiClient: APIClientType, validator: CredentialsValidatorType, router: LoginRouterType, credentialsStore: CredentialsStore) {
        self.apiClient = apiClient
        self.validator = validator
        self.router = router
        self.credentialsStore = credentialsStore
    }

    func transform(input: CreateAccountViewModelInput) -> CreateAccountViewModelOutput {
        let activityIndicator = ActivityIndicator()

        let credentials = Driver.combineLatest(input.mail, input.password, input.username) {
            return RegistrationCredentials(email: $0 ?? "", password: $1 ?? "", username: $2 ?? "")
        }

        let viewTapped = input.viewTap
            .flatMapLatest {_ in
                return Driver<Bool>.just(true)
        }

        let passwordConfirm = Driver.combineLatest(input.password, input.passwordConfirm) {
            $0 == $1 && $0?.count != 0 && $1?.count != 0
        }
        .startWith(false)

        let buttonIsEnabled = Driver.combineLatest(credentials, passwordConfirm) {
            return self.validator.areCredentialsValid(credentials: $0) && $1
        }
        .startWith(false)

        let errorMessageIsHidden = Driver.combineLatest(credentials, passwordConfirm) {
                self.validator.areCredentialsValid(credentials: $0) && $1
                    || ($0.email.count == 0 && $0.password.count == 0)
            }

        let didStartLoading = input.createButtonClick
            .withLatestFrom(credentials)
            .flatMapLatest {
                return self.apiClient
                    .request(endpoint: .createAccount(with: $0))
                    .trackActivity(activityIndicator)
                    .asDriver(onErrorDo: self.router.showError)
                    .map {
                        print($0)

                        self.credentialsStore.credentials =
                            UserCredentials(
                            token: $0.token,
                            username: $0.username)
                    }
            }
            .flatMapLatest {
                self.router
                    .showLibraryScreen()
                    .asDriver(onErrorJustReturn: ())
            }

        let backButtonClick = input.backButtonClick
            .flatMapLatest {
                self.router.showWelcomeScreen()
                    .asDriver(onErrorJustReturn: ())
            }

        return CreateAccountViewModelOutput(
            areCredentialsValid: errorMessageIsHidden,
            triggers: .merge(didStartLoading, backButtonClick),
            isLoading: activityIndicator.asDriver(),
            areUIElementsHidden: activityIndicator.asDriver(),
            buttonIsEnabled: buttonIsEnabled,
            isPasswordConfirmed: passwordConfirm,
            hideKeyboard: viewTapped,
            transformView: input.keyboardNotifications)
    }
}
