//
//  LoginRouter.swift
//  iTechBook
//
//  Created by Neestackich on 4.01.21.
//

import UIKit
import RxSwift
import RxCocoa

protocol LoginRouterType: BaseRouterType {
    func showLibraryScreen() -> Single<Void>
    func showWelcomeScreen() -> Single<Void>
}

final class LoginRouter: BaseRouter, LoginRouterType {
    func showWelcomeScreen() -> Single<Void> {
        .create { _ in
            self.rootViewController?.dismiss(animated: true, completion: nil)

            return Disposables.create()
        }
    }

    func showLibraryScreen() -> Single<Void> {
        return .create { _ in
            let libraryViewController = LibraryViewController.instantiateFromStoryboard()
            let libraryTitle = L10n.libraryLabel
            libraryViewController.title = libraryTitle
            libraryViewController.viewModel = LibraryViewModel(
                apiClient: DependencyResolver.shared.apiClient,
                router: LibraryRouter(rootViewController: libraryViewController),
                credentialsStore: DependencyResolver.shared.keychain,
                database: DependencyResolver.shared.database)

            let accountViewController = AccountViewController.instantiateFromStoryboard()
            let accountTitle = L10n.accountLabel
            accountViewController.title = accountTitle
            accountViewController.viewModel = AccountViewModel(
                apiClient: DependencyResolver.shared.apiClient,
                router: AccountRouter(rootViewController: accountViewController),
                credentialsStore: DependencyResolver.shared.keychain,
                database: DependencyResolver.shared.database)

            let tabBarController = UITabBarController()

            tabBarController.setViewControllers([libraryViewController,
                                                     accountViewController],
                                                    animated: true)
            tabBarController.modalPresentationStyle = .fullScreen
            tabBarController.tabBar.accessibilityIdentifier = "tabBarController"
            tabBarController.tabBar.items?[0].accessibilityIdentifier = "libraryTabBarItem"
            tabBarController.tabBar.items?[1].accessibilityIdentifier = "accountTabBarItem"

            let images = ["books.vertical.fill", "person.fill"]

            if let items = tabBarController.tabBar.items {
                for (index, item) in items.enumerated() {
                    item.image = UIImage(systemName: images[index])
                }
            }

            let window = UIApplication.shared.windows.first
            window?.switchRootController(to: tabBarController,
                                         options: .transitionFlipFromRight)
            return Disposables.create()
        }
    }
}
