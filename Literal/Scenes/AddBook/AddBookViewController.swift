//
//  AddBookViewController.swift
//  iTechBook
//
//  Created by Neestackich on 30.12.20.
//

import UIKit
import RxSwift
import RxCocoa

final class AddBookViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet private var doneButton: UIButton!
    @IBOutlet private var backButton: UIButton!
    @IBOutlet private var bookNameTextField: UITextField!
    @IBOutlet private var bookAuthorTextField: UITextField!
    @IBOutlet private var loadingActivityIndicator: UIActivityIndicatorView!

    var viewModel: AddBookViewModelType? {
        didSet {
            loadViewIfNeeded()
            bindViewModel()
        }
    }

    private var disposeBag = DisposeBag()

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        bookNameTextField.layer.cornerRadius = 20
        bookAuthorTextField.layer.cornerRadius = 20
        bookNameTextField.accessibilityIdentifier = "addBookScreenNameTextField"
        bookAuthorTextField.accessibilityIdentifier = "addBookScreenAuthorTextField"
        doneButton.accessibilityIdentifier = "addBookScreenDoneButton"
        backButton.accessibilityIdentifier = "addBookScreenBackButton"

        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(hideKeyboard)))

        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        self.view.insertSubview(blurEffectView, at: 0)
    }

    private func bindViewModel() {
        disposeBag = DisposeBag()

        if let viewModel = viewModel {
            let output = viewModel.transform(
                input: .init(
                    doneClick: doneButton.rx.tap.asDriver(),
                    backClick: backButton.rx.tap.asDriver(),
                    nameTextField: bookNameTextField.rx.text.asDriver(),
                    authorTextField: bookAuthorTextField.rx.text.asDriver())
            )

            disposeBag.insert(output.triggers.drive(),
                              output.isValidName.drive(doneButton.rx.isEnabled),
                              output.isLoading.drive(
                                loadingActivityIndicator.rx.isAnimating,
                                doneButton.rx.isHidden))
        }
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}
