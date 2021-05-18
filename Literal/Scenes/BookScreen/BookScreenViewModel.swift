//
//  BookScreenViewModel.swift
//  iTechBook
//
//  Created by Neestackich on 3.01.21.
//

import UIKit
import RxSwift
import RxCocoa

struct BookScreenViewModelInput {
    let backClick: Driver<Void>
    let refreshTrigger: ControlEvent<Bool>
}

struct BookScreenViewModelOutput {
    let ownerId: Driver<String>
    let name: Driver<String>
    let status: Driver<String>
    let uploadedAt: Driver<String>
    let bookId: Driver<String>
    let triggers: Driver<Void>
}

protocol BookScreenViewModelType {
    func transform(input: BookScreenViewModelInput) -> BookScreenViewModelOutput
}

final class BookScreenViewModel: BookScreenViewModelType {

    // MARK: - Properties
    private let router: BookScreenRouterType
    private let book: Book

    // MARK: - Methods

    init(router: BookScreenRouterType,
         book: Book) {
        self.router = router
        self.book = book
    }

    func transform(input: BookScreenViewModelInput) -> BookScreenViewModelOutput {
        let dateFormatter = DateFormatter.YYYYMMDD

        let backButtonClick = input.backClick
            .flatMapLatest {
                self.router.showLibraryScreen()
                    .asDriver(onErrorJustReturn: ())
            }

        let bookDriver = Driver<Book>.just(book)

        return .init(
                ownerId: bookDriver.map { String($0.ownerId) },
                name: bookDriver.map { $0.name },
                status: bookDriver.map { $0.status.readableName },
            uploadedAt: bookDriver.map { dateFormatter.string(from: $0.createdAt) },
            bookId: bookDriver.map { String($0.id) },
                triggers: backButtonClick)
    }
}
