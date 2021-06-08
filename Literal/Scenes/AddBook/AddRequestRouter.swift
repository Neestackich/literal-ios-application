//
//  AddRequestRouter.swift
//  Literal
//
//  Created by Neestackich on 4.01.21.
//

import UIKit
import RxSwift
import RxCocoa

protocol AddRequestRouterType: BaseRouterType {
    func backToRequestsList()
}

final class AddRequestRouter: BaseRouter, AddRequestRouterType {
    func backToRequestsList() {
            rootViewController?.dismiss(
                animated: true,
                completion: nil)
    }
}
