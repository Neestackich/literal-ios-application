//
//  AddRequestViewModel.swift
//  Literal
//
//  Created by Neestackich on 14.12.20.
//

import UIKit
import RxSwift
import RxCocoa

struct AddRequestViewModelInput {
    let doneClick: Driver<Void>
    let backClick: Driver<Void>
    let imageData: Driver<UIImage>
}

struct AddRequestViewModelOutput {
    let isLoading: Driver<Bool>
    let triggers: Driver<Void>
}

protocol AddRequestViewModelType {
    func transform(input: AddRequestViewModelInput) -> AddRequestViewModelOutput
}

final class AddRequestViewModel: AddRequestViewModelType {

    // MARK: - Properties

    private let apiClient: APIClientType
    private let router: AddRequestRouterType

    // MARK: - Methods

    init(apiClient: APIClientType, router: AddRequestRouterType) {
        self.apiClient = apiClient
        self.router = router
    }

    func transform(input: AddRequestViewModelInput) -> AddRequestViewModelOutput {
        let activityIndicator = ActivityIndicator()

        let didStartLoading = input.doneClick
            .withLatestFrom(input.imageData.map { $0 })
            .flatMapLatest {
                self.apiClient.request(endpoint: .addRequest(with: .init(image: $0.jpegData(compressionQuality: 1))))
                    .trackActivity(activityIndicator)
                    .asDriver(onErrorDo: self.router.showError)
                    .mapToVoid()
            }
            .do(onNext: {
                self.router
                    .backToRequestsList()
            })

        let backButtonClick = input.backClick
            .do(onNext: {
                self.router.backToRequestsList()
            })

        return .init(
            isLoading: activityIndicator.asDriver(),
            triggers: .merge(didStartLoading, backButtonClick))
    }
}
