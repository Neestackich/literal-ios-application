//
//  AddBookRouter.swift
//  iTechBook
//
//  Created by Neestackich on 4.01.21.
//

import UIKit
import RxSwift
import RxCocoa

protocol AddBookRouterType: BaseRouterType {
    func backToLibrary()
}

final class AddBookRouter: BaseRouter, AddBookRouterType {
    func backToLibrary() {
            rootViewController?.dismiss(
                animated: true,
                completion: nil)
    }
}
