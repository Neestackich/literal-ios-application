//
//  WelcomeScreenViewModel.swift
//  iTechBook
//
//  Created by Neestackich on 3.12.20.
//

import UIKit
import RxSwift
import RxCocoa

struct WelcomeScreenViewModelInput {
    let loginButtonClick: Driver<Void>
    let createAccountButtonClick: Driver<Void>
}

struct WelcomeScreenViewModelOutput {
    let triggers: Driver<Void>
}

protocol WelcomeScreenViewModelType {
    func transform(input: WelcomeScreenViewModelInput) -> WelcomeScreenViewModelOutput
}

final class WelcomeScreenViewModel: WelcomeScreenViewModelType {

    // MARK: - Properties

    private let router: WelcomeScreenRouterType

    // MARK: - Methods

    init(router: WelcomeScreenRouterType) {
        self.router = router
    }

    func transform(input: WelcomeScreenViewModelInput) -> WelcomeScreenViewModelOutput {
        let showLoginScreen = input.loginButtonClick
            .flatMapLatest {
                self.router.showLoginScreen()
                    .asDriver(onErrorJustReturn: ())
            }

        let showCreateAccountScreen = input.createAccountButtonClick
            .flatMapLatest {
                self.router.showCreateAccountScreen()
                    .asDriver(onErrorJustReturn: ())
            }

        return WelcomeScreenViewModelOutput(
            triggers: .merge(
                showLoginScreen,
                showCreateAccountScreen))
    }
}
