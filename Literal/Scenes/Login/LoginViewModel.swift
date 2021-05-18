//
//  LoginViewModel.swift
//  iTechBook
//
//  Created by Neestackich on 24.11.20.
//

import UIKit
import RxSwift
import RxCocoa

struct LoginViewModelInput {
    let mail: Driver<String?>
    let password: Driver<String?>
    let loginButtonClick: Driver<Void>
    let backButtonClick: Driver<Void>
    let viewTap: Driver<UITapGestureRecognizer>
    let keyboardNotifications: Driver<Notification>
}

struct LoginViewModelOutput {
    let errorMessageIsHidden: Driver<Bool>
    let triggers: Driver<Void>
    let isLoading: Driver<Bool>
    let areUIElementsHidden: Driver<Bool>
    let buttonIsEnabled: Driver<Bool>
    let hideKeyboard: Driver<Bool>
    let transformView: Driver<Notification>
}

protocol LoginViewModelType {
    func transform(input: LoginViewModelInput) -> LoginViewModelOutput
}

final class LoginViewModel: LoginViewModelType {

    // MARK: - Properties

    private let router: LoginRouterType
    private let apiClient: APIClientType
    private let validator: CredentialsValidatorType
    private var credentialsStore: CredentialsStore

    // MARK: - Methods

    init(apiClient: APIClientType, validator: CredentialsValidatorType, router: LoginRouterType, credentialsStore: CredentialsStore) {
        self.apiClient = apiClient
        self.validator = validator
        self.router = router
        self.credentialsStore = credentialsStore
    }

    func transform(input: LoginViewModelInput) -> LoginViewModelOutput {
        let activityIndicator = ActivityIndicator()

        let credentials = Driver.combineLatest(input.mail, input.password) {
            return Credentials(mail: $0 ?? "", password: $1 ?? "")
        }

        let viewTapped = input.viewTap
            .flatMapLatest {_ in
                return Driver<Bool>.just(true)
            }

        let buttonIsEnabled = credentials
            .map {
                self.validator.areCredentialsValid(credentials: $0)
            }

        let errorMessageIsHidden = credentials
            .map {
                self.validator.areCredentialsValid(credentials: $0)
                    || ($0.mail.count == 0 && $0.password.count == 0)
            }

        let didStartLoading = input.loginButtonClick
            .withLatestFrom(credentials)
            .flatMapLatest {
                return self.apiClient
                    .request(endpoint: .login(with: $0))
                    .trackActivity(activityIndicator)
                    .asDriver(onErrorDo: self.router.showError)
                    .map {
                        print($0.data.token)

                        self.credentialsStore.credentials =
                            UserCredentials(
                            token: $0.data.token,
                            id: $0.data.id,
                            email: $0.data.mail)
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

        return LoginViewModelOutput(
            errorMessageIsHidden: errorMessageIsHidden,
            triggers: .merge(didStartLoading, backButtonClick),
            isLoading: activityIndicator.asDriver(),
            areUIElementsHidden: activityIndicator.asDriver(),
            buttonIsEnabled: buttonIsEnabled,
            hideKeyboard: viewTapped,
            transformView: input.keyboardNotifications)
    }
}

extension SharedSequence where SharingStrategy == DriverSharingStrategy {
    func mapToVoid() -> Driver<Void> {
        map { _ in () }
    }
}
