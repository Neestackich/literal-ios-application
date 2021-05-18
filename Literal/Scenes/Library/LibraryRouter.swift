//
//  LibraryRouter.swift
//  iTechBook
//
//  Created by Neestackich on 4.01.21.
//

import UIKit
import RxSwift
import RxCocoa

protocol LibraryRouterType: BaseRouterType {
    func showAddBookScreen() -> Single<Void>
    func showBookScreen(book: Book) -> Single<Void>
}

final class LibraryRouter: BaseRouter, LibraryRouterType {
    func showAddBookScreen() -> Single<Void> {
        return .create { _ in
            let addBookViewController = AddBookViewController
                .instantiateFromStoryboard()
            addBookViewController.viewModel =
                AddBookViewModel(
                    apiClient: DependencyResolver.shared.apiClient,
                    router: AddBookRouter(rootViewController: addBookViewController))

            self.rootViewController?.present(
                addBookViewController,
                animated: true,
                completion: nil)

            return Disposables.create()
        }
    }

    func showBookScreen(book: Book) -> Single<Void> {
        return .create { _ in
            let bookScreenaddBookViewController = BookScreenViewController.instantiateFromStoryboard()
            bookScreenaddBookViewController.viewModel =
                BookScreenViewModel(
                    router: BookScreenRouter(
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
