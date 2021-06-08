//
//  RequestScreenViewModel.swift
//  Literal
//
//  Created by Neestackich on 3.01.21.
//

import UIKit
import RxSwift
import RxCocoa

struct RequestScreenViewModelInput {
    let backClick: Driver<Void>
    let refreshTrigger: ControlEvent<Bool>
}

struct RequestScreenViewModelOutput {
    let ownerId: Driver<String>
    let name: Driver<String>
    let status: Driver<String>
    let uploadedAt: Driver<String>
    let bookId: Driver<String>
    let triggers: Driver<Void>
}

protocol RequestScreenViewModelType {
    func transform(input: RequestScreenViewModelInput) -> RequestScreenViewModelOutput
}

final class RequestScreenViewModel: RequestScreenViewModelType {

    // MARK: - Properties
    private let router: RequestScreenRouterType
    private let book: Book

    // MARK: - Methods

    init(router: RequestScreenRouterType,
         book: Book) {
        self.router = router
        self.book = book
    }

    func transform(input: RequestScreenViewModelInput) -> RequestScreenViewModelOutput {
        let dateFormatter = DateFormatter.YYYYMMDD

        let backButtonClick = input.backClick
            .flatMapLatest {
                self.router.showLibraryScreen()
                    .asDriver(onErrorJustReturn: ())
            }

        let requestDriver = Driver<Book>.just(book)

        return .init(
                ownerId: requestDriver.map { String($0.ownerId) },
                name: requestDriver.map { $0.name },
                status: requestDriver.map { $0.status.readableName },
            uploadedAt: requestDriver.map { dateFormatter.string(from: $0.createdAt) },
            bookId: requestDriver.map { String($0.id) },
                triggers: backButtonClick)
    }
}
