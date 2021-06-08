//
//  UIWindow+Extension.swift
//  Literal
//
//  Created by Neestackich on 16.02.21.
//

import UIKit

extension UIWindow {
    func switchRootController(to viewController: UIViewController,
                              animated: Bool = true,
                              duration: TimeInterval = 0.5,
                              options: UIView.AnimationOptions,
                              _ completion: (() -> Void)? = nil) {
        guard animated else {
            rootViewController = viewController
            return
        }

        UIView.transition(with: self,
                          duration: duration,
                          options: options,
                          animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            self.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
            }, completion: { _ in
                completion?()
            })
    }
}
