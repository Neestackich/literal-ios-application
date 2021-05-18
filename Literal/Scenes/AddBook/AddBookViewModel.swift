//
//  AddBookViewModel.swift
//  iTechBook
//
//  Created by Neestackich on 14.12.20.
//

import UIKit
import RxSwift
import RxCocoa

struct AddBookViewModelInput {
    let doneClick: Driver<Void>
    let backClick: Driver<Void>
    let nameTextField: Driver<String?>
    let authorTextField: Driver<String?>
}

struct AddBokViewModelOutput {
    let isValidName: Driver<Bool>
    let isLoading: Driver<Bool>
    let triggers: Driver<Void>
}

protocol AddBookViewModelType {
    func transform(input: AddBookViewModelInput) -> AddBokViewModelOutput
}

final class AddBookViewModel: AddBookViewModelType {

    // MARK: - Properties

    private let apiClient: APIClientType
    private let router: AddBookRouterType

    // MARK: - Methods

    init(apiClient: APIClientType, router: AddBookRouterType) {
        self.apiClient = apiClient
        self.router = router
    }

    func transform(input: AddBookViewModelInput) -> AddBokViewModelOutput {
        let activityIndicator = ActivityIndicator()

        let bookCredentials = Driver.combineLatest(input.nameTextField, input.authorTextField) {

            return BookData(name: ($0 ?? "") + " " + ($1 ?? ""))
        }

        let isValid = bookCredentials
            .map {
                return $0.name.count > 1
            }
            .startWith(false)

        let didStartLoading = input.doneClick
            .withLatestFrom(bookCredentials)
            .flatMapLatest {
                self.apiClient.request(endpoint: .addBook(with: $0))
                    .trackActivity(activityIndicator)
                    .asDriver(onErrorDo: self.router.showError)
                    .mapToVoid()
            }
            .do(onNext: {
                self.router
                    .backToLibrary()
            })

        let backButtonClick = input.backClick
            .do(onNext: {
                self.router.backToLibrary()
            })

        return .init(
            isValidName: isValid,
            isLoading: activityIndicator.asDriver(),
            triggers: .merge(didStartLoading, backButtonClick))
    }
}
