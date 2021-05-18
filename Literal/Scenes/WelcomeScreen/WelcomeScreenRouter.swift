//
//  WelcomeScreenRouter.swift
//  iTechBook
//
//  Created by Neestackich on 4.01.21.
//

import UIKit
import RxSwift
import RxCocoa

protocol WelcomeScreenRouterType: BaseRouterType {
    func showLoginScreen() -> Single<Void>
    func showCreateAccountScreen() -> Single<Void>
}

final class WelcomeScreenRouter: BaseRouter, WelcomeScreenRouterType {
    func showLoginScreen() -> Single<Void> {
        return .create { _ in
            let loginScreen = LoginViewController.instantiateFromStoryboard()
            loginScreen.viewModel = LoginViewModel(
                apiClient: DependencyResolver.shared.apiClient,
                validator: DependencyResolver.shared.validator,
                router: LoginRouter(rootViewController: loginScreen),
                credentialsStore: DependencyResolver.shared.keychain)
            loginScreen.modalPresentationStyle = .fullScreen

            self.rootViewController?.present(loginScreen, animated: true)

            return Disposables.create()
        }
    }

    func showCreateAccountScreen() -> Single<Void> {
        return .create { _ in
            let createAccountScreen = CreateAccountViewController.instantiateFromStoryboard()
            createAccountScreen.viewModel = CreateAccountViewModel(
                apiClient: DependencyResolver.shared.apiClient,
                validator: DependencyResolver.shared.validator,
                router: LoginRouter(rootViewController: createAccountScreen),
                credentialsStore: DependencyResolver.shared.keychain)
            createAccountScreen.modalPresentationStyle = .fullScreen

            self.rootViewController?.present(createAccountScreen, animated: true)

            return Disposables.create()
        }
    }
}
