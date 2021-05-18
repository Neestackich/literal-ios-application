//
//  BookScreenViewController.swift
//  iTechBook
//
//  Created by Neestackich on 3.01.21.
//

import UIKit
import RxSwift
import RxCocoa

final class BookScreenViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet private var mainContentView: UIView!
    @IBOutlet private var backButton: UIButton!
    @IBOutlet private var statusLabel: UILabel!
    @IBOutlet private var ownerIdLabel: UILabel!
    @IBOutlet private var bookIdLabel: UILabel!
    @IBOutlet private var bookNameLabel: UILabel!
    @IBOutlet private var uploadedAtLabel: UILabel!

    var viewModel: BookScreenViewModelType? {
        didSet {
            loadViewIfNeeded()
            bindViewModel()
        }
    }

    private var disposeBag = DisposeBag()

    // MARK: - Methods

    override func viewDidLoad() {
        setup()
    }

    private func setup() {
        mainContentView.layer.cornerRadius = 25

        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        self.view.insertSubview(blurEffectView, at: 0)
        backButton.accessibilityIdentifier = "bookScreenBackButton"
    }

    private func bindViewModel() {
        disposeBag = .init()

        if let viewModel = viewModel {
            let output = viewModel.transform(input: .init(
                    backClick: backButton.rx.tap.asDriver(),
                    refreshTrigger: self.rx.viewDidAppear))

            disposeBag.insert(
                output.ownerId.drive(ownerIdLabel.rx.text),
                output.name.drive(bookNameLabel.rx.text),
                output.status.drive(statusLabel.rx.text),
                output.uploadedAt.drive(uploadedAtLabel.rx.text),
                output.bookId.drive(bookIdLabel.rx.text),
                output.triggers.drive())
        }
    }
}
