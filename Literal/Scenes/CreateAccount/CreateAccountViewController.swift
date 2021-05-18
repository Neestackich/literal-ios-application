//
//  CreateAccountViewController.swift
//  iTechBook
//
//  Created by Neestackich on 2.12.20.
//

import UIKit
import RxSwift
import RxCocoa

final class CreateAccountViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Properties

    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var appLogoImageView: UIImageView!
    @IBOutlet private var createAccountButton: UIButton!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var credentialsErrorLabel: UILabel!
    @IBOutlet private var backToWelcomeScreenButton: UIButton!
    @IBOutlet private var confirmPasswordTextField: UITextField!
    @IBOutlet private var createAccountActivityIndicator: UIActivityIndicatorView!

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    private var disposeBag = DisposeBag()

    var viewModel: CreateAccountViewModelType? {
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
        emailTextField.layer.cornerRadius = 20
        passwordTextField.layer.cornerRadius = 20
        createAccountButton.layer.cornerRadius = 20
        confirmPasswordTextField.layer.cornerRadius = 20
        createAccountButton.accessibilityIdentifier = "createAccountCreateButton"
        emailTextField.accessibilityIdentifier = "createAccountEmailTextField"
        passwordTextField.accessibilityIdentifier = "createAccountPasswordTextfield"
        confirmPasswordTextField.accessibilityIdentifier = "createAccountConfirmPasswordTextfield"
        backToWelcomeScreenButton.accessibilityIdentifier = "createAccountBackButton"
    }

    private func bindViewModel() {
        disposeBag = DisposeBag()

        if let viewModel = viewModel {
            let output = viewModel.transform(input:
                .init(mail: emailTextField.rx.text.asDriver(),
                      password: passwordTextField.rx.text.asDriver(),
                      passwordConfirm: confirmPasswordTextField.rx.text.asDriver(),
                      createButtonClick: createAccountButton.rx.tap.asDriver(),
                      backButtonClick: backToWelcomeScreenButton.rx.tap.asDriver(),
                      viewTap: view.rx.tapGesture().asDriver(),
                      keyboardNotifications:
                        .merge(NotificationCenter.default.rx
                                .notification(UIResponder.keyboardWillShowNotification)
                                .asDriver(onErrorDriveWith: .empty()),
                               NotificationCenter.default.rx
                                .notification(UIResponder.keyboardWillHideNotification)
                                .asDriver(onErrorDriveWith: .empty()))))

            disposeBag.insert(
                output.triggers.drive(),
                output.transformView.drive(view.rx.transformView),
                output.hideKeyboard.drive(view.rx.isKeyboardHidden),
                output.buttonIsEnabled.drive(createAccountButton.rx.isEnabled),
                output.isPasswordConfirmed.drive(createAccountButton.rx.isEnabled),
                output.areCredentialsValid.drive(credentialsErrorLabel.rx.isHidden),
                output.isLoading.drive(createAccountActivityIndicator.rx.isAnimating,
                                       view.rx.isKeyboardHidden),
                output.areUIElementsHidden.drive(createAccountButton.rx.isHidden,
                                                 emailTextField.rx.isHidden,
                                                 passwordTextField.rx.isHidden,
                                                 confirmPasswordTextField.rx.isHidden))
        }
    }
}
