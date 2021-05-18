//
//  UIView+RxExtension.swift
//  iTechBook
//
//  Created by Neestackich on 18.02.21.
//

import Foundation
import RxSwift

extension Reactive where Base: UIView {
    var isKeyboardHidden: Binder<Bool> {
        return Binder(base) { _, isHidden in
            if isHidden {
                base.endEditing(isHidden)
            }
        }
    }

    var transformView: Binder<Notification> {
        return Binder(base) { _, notification in
            guard let keyboard = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
            }

            if notification.name == UIResponder.keyboardWillShowNotification {
                base.transform = CGAffineTransform(
                    translationX: 0,
                    y: -keyboard.height)
            } else {
                base.transform = .identity
            }
        }
    }
}
