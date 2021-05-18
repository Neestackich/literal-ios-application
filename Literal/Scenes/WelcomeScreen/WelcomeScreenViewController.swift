//
//  WelcomeScreenViewController.swift
//  iTechBook
//
//  Created by Neestackich on 3.12.20.
//

import UIKit
import RxSwift
import RxCocoa

final class WelcomeScreenViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet private var appLogoImageView: UIImageView!
    @IBOutlet private var loginButton: UIButton!
    @IBOutlet private var createAccountButton: UIButton!

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    private var disposeBag = DisposeBag()

    var viewModel: WelcomeScreenViewModelType? {
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
        loginButton.layer.cornerRadius = 28
        createAccountButton.layer.cornerRadius = 28

        loginButton.accessibilityIdentifier = "welocomeScreenLoginButton"
        createAccountButton.accessibilityIdentifier = "welocomeScreenCreateButton"
    }

    private func bindViewModel() {
        disposeBag = DisposeBag()

        if let viewModel = viewModel {
            let output = viewModel.transform(
                input: WelcomeScreenViewModelInput(
                        loginButtonClick: loginButton.rx.tap.asDriver(),
                        createAccountButtonClick: createAccountButton.rx.tap.asDriver()))

            disposeBag.insert(output.triggers.drive())
        }
    }
}
