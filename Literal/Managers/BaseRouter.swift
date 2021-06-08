//
//  BaseRouter.swift
//  Literal
//
//  Created by Neestackich on 26.01.21.
//

import UIKit
import AudioToolbox

protocol BaseRouterType {
    func showError(title: String, message: String)
    func showError(_ error: Error)
}

class BaseRouter: BaseRouterType {

    // MARK: - Properties

    weak var rootViewController: UIViewController?

    // MARK: - Methods

    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }

    func showError(title: String, message: String) {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurVisualEffectView.frame = rootViewController!.view.bounds
        rootViewController!.view.addSubview(blurVisualEffectView)

        let errorAlert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        errorAlert.view.accessibilityIdentifier = "errorAlert"
        let okTitle = L10n.okButton
        errorAlert.addAction(UIAlertAction(title: okTitle, style: .cancel) { _ in
            blurVisualEffectView.removeFromSuperview()
        })

        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        rootViewController?.present(errorAlert, animated: true)
    }

    func showError(_ error: Error) {
        let title = L10n.errorTitle
        showError(title: title, message: error.localizedDescription)
    }
}
