//
//  LibraryViewModel.swift
//  iTechBook
//
//  Created by Neestackich on 7.12.20.
//

import UIKit
import RxSwift
import RxCocoa

struct LibraryViewModelInput {
    let addBookButton: Driver<Void>
    let cellSelection: Driver<Book>
}

struct LibraryViewModelOutput {
    let books: Driver<[Book]>
    let triggers: Driver<Void>
    let booksQuantity: Driver<String>
    let mineBooksQuantity: Driver<String>
    let isLoading: Driver<Bool>
    let isDataEmpty: Driver<Bool>
}

protocol LibraryViewModelType {
    func transform(input: LibraryViewModelInput) -> LibraryViewModelOutput
}

final class LibraryViewModel: LibraryViewModelType {

    // MARK: - Properties

    private var apiClient: APIClientType
    private var router: LibraryRouterType
    private let credentialsStore: CredentialsStore
    private let database: BookStorageType

    // MARK: - Methods

    init(apiClient: APIClientType, router: LibraryRouterType, credentialsStore: CredentialsStore, database: BookStorageType) {
        self.apiClient = apiClient
        self.router = router
        self.credentialsStore = credentialsStore
        self.database = database
    }

    func transform(input: LibraryViewModelInput) -> LibraryViewModelOutput {
        let activityIndicator = ActivityIndicator()

        let booksFromServer = self.apiClient.request(endpoint: .getBooks())
            .trackActivity(activityIndicator)
            .map { $0.data }
            .flatMap(database.saveBooks)
            .asDriver(onErrorDo: router.showError)

        let booksFromDatabase = self.database.getAllBooks()
            .asDriver(onErrorDo: router.showError)

        let serverBooksQuantity = booksFromServer.map { books -> String in
            if books.count > 1 {
                return "\(books.count)"
            } else {
                return "\(books.count)"
            }
        }

        let databaseBooksQuantity = booksFromDatabase.map { books -> String in
            if books.count > 1 {
                return "\(books.count)"
            } else {
                return "\(books.count)"
            }
        }

        let mineServerBooksQuantity = booksFromServer.map { books -> String in
            var counter = 0
            let currentUserID = self.credentialsStore.credentials?.id

            for book in books {
                if let currentUserID = currentUserID {
                    if book.ownerId == currentUserID {
                        counter += 1
                    }
                }
            }

            return "\(counter)"
        }

        let mineDatabaseBooksQuantity = booksFromDatabase.map { books -> String in
            var counter = 0
            let currentUserID = self.credentialsStore.credentials?.id

            for book in books {
                if let currentUserID = currentUserID {
                    if book.ownerId == currentUserID {
                        counter += 1
                    }
                }
            }

            return "\(counter)"
        }

        let isServerDataEmpty = booksFromServer.map {
            $0.count == 0
        }
        .asDriver()

        let isDatabaseDataEmpty = booksFromDatabase.map {
            $0.count == 0
        }
        .asDriver()

        let cellSelected = input.cellSelection
            .flatMapLatest {
                self.router.showBookScreen(book: $0)
                    .asDriver(onErrorJustReturn: ())
            }

        let showAddBookScreen = input.addBookButton
            .flatMapLatest {
                self.router.showAddBookScreen()
                    .asDriver(onErrorJustReturn: ())
            }

        return .init(
            books: .merge(booksFromServer, booksFromDatabase),
            triggers: .merge(showAddBookScreen, cellSelected),
            booksQuantity: .merge(serverBooksQuantity,
                                  databaseBooksQuantity),
            mineBooksQuantity: .merge(mineServerBooksQuantity,
                                      mineDatabaseBooksQuantity),
            isLoading: activityIndicator.asDriver(),
            isDataEmpty: .merge(isServerDataEmpty.map { !$0 },
                                isDatabaseDataEmpty.map { !$0 }))
    }
}
