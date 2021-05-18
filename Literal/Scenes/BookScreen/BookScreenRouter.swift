//
//  BookScreenRouter.swift
//  iTechBook
//
//  Created by Neestackich on 7.01.21.
//

import UIKit
import RxSwift
import RxCocoa

protocol BookScreenRouterType {
    func showLibraryScreen() -> Single<Void>
}

final class BookScreenRouter: BaseRouter, BookScreenRouterType {
    func showLibraryScreen() -> Single<Void> {
        .create { _ in
            self.rootViewController?.dismiss(animated: true, completion: nil)

            return Disposables.create()
        }
    }
}
