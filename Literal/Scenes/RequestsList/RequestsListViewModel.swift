//
//  RequestsListViewModel.swift
//  Literal
//
//  Created by Neestackich on 7.12.20.
//

import UIKit
import RxSwift
import RxCocoa

struct RequestsListViewModelInput {
    let addRequestButton: Driver<Void>
    let cellSelection: Driver<Book>
}

struct RequestsListViewModelOutput {
    let requests: Driver<[Book]>
    let triggers: Driver<Void>
    let requestsQuantity: Driver<String>
    let isLoading: Driver<Bool>
    let isDataEmpty: Driver<Bool>
}

protocol RequestsListViewModelType {
    func transform(input: RequestsListViewModelInput) -> RequestsListViewModelOutput
}

final class RequestsListViewModel: RequestsListViewModelType {

    // MARK: - Properties

    private var apiClient: APIClientType
    private var router: RequestsListRouterType
    private let credentialsStore: CredentialsStore
    private let database: BookStorageType

    // MARK: - Methods

    init(apiClient: APIClientType, router: RequestsListRouterType, credentialsStore: CredentialsStore, database: BookStorageType) {
        self.apiClient = apiClient
        self.router = router
        self.credentialsStore = credentialsStore
        self.database = database
    }

    func transform(input: RequestsListViewModelInput) -> RequestsListViewModelOutput {
        let activityIndicator = ActivityIndicator()

        let requestsFromServer = self.apiClient.request(endpoint: .getRequests())
            .trackActivity(activityIndicator)
            .map { $0 }
            .flatMap(database.saveBooks)
            .asDriver(onErrorDo: router.showError)

        let requestsFromDatabase = self.database.getAllBooks()
            .asDriver(onErrorDo: router.showError)

        let serverRequestsQuantity = requestsFromServer.map { books -> String in
            if books.count > 1 {
                return "\(books.count)"
            } else {
                return "\(books.count)"
            }
        }

        let databaseRequestsQuantity = requestsFromDatabase.map { books -> String in
            if books.count > 1 {
                return "\(books.count)"
            } else {
                return "\(books.count)"
            }
        }

        let isServerDataEmpty = requestsFromServer.map {
            $0.count == 0
        }
        .asDriver()

        let isDatabaseDataEmpty = requestsFromDatabase.map {
            $0.count == 0
        }
        .asDriver()

        let cellSelected = input.cellSelection
            .flatMapLatest {
                self.router.showRequestScreen(book: $0)
                    .asDriver(onErrorJustReturn: ())
            }

        let showAddRequestScreen = input.addRequestButton
            .flatMapLatest {
                self.router.showAddBookScreen()
                    .asDriver(onErrorJustReturn: ())
            }

        return .init(
            requests: .merge(requestsFromServer, requestsFromDatabase),
            triggers: .merge(showAddRequestScreen, cellSelected),
            requestsQuantity: .merge(serverRequestsQuantity,
                                  databaseRequestsQuantity),
            isLoading: activityIndicator.asDriver(),
            isDataEmpty: .merge(isServerDataEmpty.map { !$0 },
                                isDatabaseDataEmpty.map { !$0 }))
    }
}
