//
//  AccountRouter.swift
//  Literal
//
//  Created by Neestackich on 5.01.21.
//

import UIKit
import RxSwift
import RxCocoa

protocol AccountRouterType: BaseRouterType {
    func showWelcomeScreen()
    func showBookScreen(book: Book) -> Single<Void>
}

final class AccountRouter: BaseRouter, AccountRouterType {

    // MARK: - Methods

    func showWelcomeScreen() {
        let window = UIApplication.shared.windows.first
        let welcomeScreenViewController = WelcomeScreenViewController.instantiateFromStoryboard()
        welcomeScreenViewController.viewModel = WelcomeScreenViewModel(router:
            WelcomeScreenRouter(rootViewController: welcomeScreenViewController))
        welcomeScreenViewController.modalPresentationStyle = .fullScreen
        window?.switchRootController(to: welcomeScreenViewController,
                                     options: .transitionFlipFromLeft)
    }

    func showBookScreen(book: Book) -> Single<Void> {
        return .create { _ in
            let bookScreenaddBookViewController = RequestScreenViewController.instantiateFromStoryboard()
            bookScreenaddBookViewController.viewModel =
                RequestScreenViewModel(
                    router: RequestScreenRouter(
                    rootViewController: bookScreenaddBookViewController),
                    book: book)

            self.rootViewController?.present(
                bookScreenaddBookViewController,
                animated: true,
                completion: nil)

            return Disposables.create()
        }
    }
}
