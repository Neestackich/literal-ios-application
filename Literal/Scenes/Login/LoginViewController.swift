//
//  LoginViewController.swift
//  iTechBook
//
//  Created by Neestackich on 24.11.20.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

final class LoginViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet private var textFieldsStackView: UIStackView!
    @IBOutlet private var loginButton: UIButton!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var appLogoImageView: UIImageView!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var loginActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private var credentialsErrorLabel: UILabel!
    @IBOutlet private var backToWelcomeScreenButton: UIButton!

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    private var disposeBag = DisposeBag()

    var viewModel: LoginViewModelType? {
        didSet {
            loadViewIfNeeded()
            bindViewModel()
        }
    }

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        loginButton.layer.cornerRadius = 20
        emailTextField.layer.cornerRadius = 20
        passwordTextField.layer.cornerRadius = 20
        loginButton.accessibilityIdentifier = "loginScrenLoginButton"
        emailTextField.accessibilityIdentifier = "loginScreenEmailTextField"
        passwordTextField.accessibilityIdentifier = "loginScreenPasswordTextfield"
        backToWelcomeScreenButton.accessibilityIdentifier = "loginScreenBackButton"
    }

    private func bindViewModel() {
        disposeBag = DisposeBag()

        if let viewModel = viewModel {
            let output = viewModel.transform(input:
                .init(mail: emailTextField.rx.text.asDriver(),
                      password: passwordTextField.rx.text.asDriver(),
                      loginButtonClick: loginButton.rx.tap.asDriver(),
                      backButtonClick: backToWelcomeScreenButton.rx.tap.asDriver(),
                      viewTap: view.rx.tapGesture().asDriver(),
                      keyboardNotifications:
                        .merge(NotificationCenter.default.rx
                                .notification(
                                    UIResponder.keyboardWillShowNotification)
                                .asDriver(onErrorDriveWith: .empty()),
                               NotificationCenter.default.rx
                                .notification(
                                    UITextField.keyboardWillHideNotification)
                                .asDriver(onErrorDriveWith: .empty()))))

            disposeBag.insert(
                output.triggers.drive(),
                output.errorMessageIsHidden.drive(credentialsErrorLabel.rx.isHidden),
                output.areUIElementsHidden.drive(loginButton.rx.isHidden,
                                            emailTextField.rx.isHidden,
                                            passwordTextField.rx.isHidden),
                output.buttonIsEnabled.drive(loginButton.rx.isEnabled),
                output.isLoading.drive(loginActivityIndicator.rx.isAnimating,
                                       view.rx.isKeyboardHidden),
                output.hideKeyboard.drive(view.rx.isKeyboardHidden),
                output.transformView.drive(view.rx.transformView))
        }
    }
}
