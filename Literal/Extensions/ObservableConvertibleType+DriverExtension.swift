//
//  ObservableConvertibleType+DriverExtension.swift
//  iTechBook
//
//  Created by Neestackich on 26.01.21.
//

import RxSwift
import RxCocoa

extension ObservableConvertibleType {
    func asDriver(onErrorDo: @escaping (_ error: Swift.Error) -> Void) -> Driver<Element> {
        return self.asDriver(onErrorRecover: { error in
            onErrorDo(error)
            return Driver.empty()
        })
    }
}
