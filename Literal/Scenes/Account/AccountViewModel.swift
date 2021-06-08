//
//  AccountViewModel.swift
//  Literal
//
//  Created by Neestackich on 31.12.20.
//

import UIKit
import RxSwift
import RxCocoa

struct AccountViewModelInput {
    let logOutClick: Driver<Void>
    let cellSelection: Driver<Book>
}

struct AccountViewModelOutput {
    let books: Driver<[Book]>
    let areBooksLoading: Driver<Bool>
    let isUserDataLoading: Driver<Bool>
    let email: Driver<String>
    let triggers: Driver<Void>
    let isDataEmpty: Driver<Bool>
}

protocol AccountViewModelType {
    func transform(input: AccountViewModelInput) -> AccountViewModelOutput
}

final class AccountViewModel: AccountViewModelType {

    // MARK: - Properties

    private let apiClient: APIClientType
    private let router: AccountRouterType
    private var credentialsStore: CredentialsStore
    private let database: BookStorageType

    // MARK: - Methods

    init(apiClient: APIClientType,
         router: AccountRouterType,
         credentialsStore: CredentialsStore,
         database: BookStorageType) {
        self.apiClient = apiClient
        self.router = router
        self.credentialsStore = credentialsStore
        self.database = database
    }

    func transform(input: AccountViewModelInput) -> AccountViewModelOutput {
        let booksActivityIndicator = ActivityIndicator()
        let userDataActivityIndicato = ActivityIndicator()

        let logOut = input.logOutClick.do(onNext: {
            self.credentialsStore.credentials = nil
            self.router.showWelcomeScreen()
        })

        let booksFromServer = self.apiClient.request(endpoint: .getOwnBooks())
            .trackActivity(booksActivityIndicator)
            .map { $0 }
            .asDriver(onErrorDriveWith: .empty())

        let booksFromDatabase = self.database.getMyBooks(ownerId: 0)
            .asDriver(onErrorDriveWith: .empty())

        let userDataFromServer = self.apiClient.request(endpoint: .showUser(with: 0))
            .trackActivity(userDataActivityIndicato)
            .map { $0 }
            .asDriver(onErrorDriveWith: .empty())

        let userDataFromKeychain = { () ->
            SharedSequence<DriverSharingStrategy, UserData> in
            guard let credentials = self.credentialsStore.credentials else {
                return Driver<UserData>.empty()
            }

            return Driver<UserData>.just(
                UserData(token: credentials.token,
                         username: credentials.username))
        }()

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

        return .init(
            books: .merge(booksFromServer, booksFromDatabase),
            areBooksLoading: booksActivityIndicator.asDriver(),
            isUserDataLoading: userDataActivityIndicato.asDriver(),
            email: .merge(userDataFromServer.map { $0.username },
                          userDataFromKeychain.map { $0.username }),
            triggers: .merge(logOut, cellSelected),
            isDataEmpty: .merge(isServerDataEmpty.map { !$0 },
                                isDatabaseDataEmpty.map { !$0 }))
    }
}
