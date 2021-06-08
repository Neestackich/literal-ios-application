//
//  RequestListRouter.swift
//  Literal
//
//  Created by Neestackich on 4.01.21.
//

import UIKit
import RxSwift
import RxCocoa

protocol RequestsListRouterType: BaseRouterType {
    func showAddBookScreen() -> Single<Void>
    func showRequestScreen(book: Book) -> Single<Void>
}

final class RequestsListRouter: BaseRouter, RequestsListRouterType {
    func showAddBookScreen() -> Single<Void> {
        return .create { _ in
            let addBookViewController = AddRequestViewController
                .instantiateFromStoryboard()
            addBookViewController.viewModel =
                AddRequestViewModel(
                    apiClient: DependencyResolver.shared.apiClient,
                    router: AddRequestRouter(rootViewController: addBookViewController))

            self.rootViewController?.present(
                addBookViewController,
                animated: true,
                completion: nil)

            return Disposables.create()
        }
    }

    func showRequestScreen(book: Book) -> Single<Void> {
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
