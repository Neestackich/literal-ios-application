//
//  UIViewController+UIStoryboard.swift
//  Literal
//
//  Created by Neestackich on 4.12.20.
//

import UIKit

extension UIStoryboard {
    func initialViewController<T: UIViewController>(ofType type: T.Type = T.self) -> T {
        instantiateInitialViewController() as! T
    }
}

extension UIViewController {
    class var defaultStoryboardName: String { String(describing: self) }

    static func instantiateFromStoryboard(named: String = defaultStoryboardName, in bundle: Bundle? = nil) -> Self {
        let storyboard = UIStoryboard(name: defaultStoryboardName, bundle: bundle)
        return storyboard.initialViewController()
    }
}
