//
//  AccountViewController.swift
//  Literal
//
//  Created by Neestackich on 31.12.20.
//

import UIKit
import RxSwift
import RxCocoa

final class AccountViewController: UIViewController, UITableViewDelegate {

    // MARK: - Properties

    @IBOutlet private var stackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private var cloudViewImage: UIImageView!
    @IBOutlet private var noDataStackView: UIStackView!
    @IBOutlet private var logOutButton: UIButton!
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var booksTableView: UITableView!
    @IBOutlet private var tableViewLoadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private var userInfoLoadingActivitiIndicator: UIActivityIndicatorView!

    var viewModel: AccountViewModelType? {
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
        booksTableView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner]
        booksTableView.layer.cornerRadius = 30
        booksTableView.accessibilityIdentifier = "accountTableView"
        logOutButton.accessibilityIdentifier = "logOutButton"
    }

    private func bindViewModel() {
        disposeBag = .init()

        if let viewModel = viewModel {
            let output = viewModel.transform(
                input: .init(logOutClick: logOutButton.rx.tap.asDriver(),
                cellSelection: booksTableView.rx.modelSelected(Book.self).asDriver()))

            disposeBag.insert(
                output.areBooksLoading.drive(
                    tableViewLoadingActivityIndicator.rx.isAnimating,
                    booksTableView.rx.isHidden),
                output.isUserDataLoading.drive(
                    userInfoLoadingActivitiIndicator.rx.isAnimating,
                    emailLabel.rx.isHidden),
                output.books.drive(booksTableView.rx.items(
                    cellIdentifier: "LibraryTableViewCell",
                    cellType: RequestTableViewCell.self)) { _, book, cell in
                            cell.viewModel = BookViewModel(book: book)
                            cell.accessibilityIdentifier = "accountTableViewCell"
                    },
                output.email.drive(emailLabel.rx.text),
                output.triggers.drive(),
                output.isDataEmpty.drive(noDataStackView.rx.isHidden,
                                         booksTableView.rx.isScrollEnabled)
            )
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y - CGPoint.zero.y

        if contentOffset > 0 && scrollView.contentOffset.y > 0 {
            if stackViewTopConstraint.constant > -240 {
                stackViewTopConstraint.constant -= contentOffset
                scrollView.contentOffset.y -= contentOffset
            }
        } else if contentOffset < 0 && scrollView.contentOffset.y < 0 {
            if stackViewTopConstraint.constant < 0 {
                if stackViewTopConstraint.constant - contentOffset > 0 {
                    stackViewTopConstraint.constant = 0
                } else {
                    stackViewTopConstraint.constant -= contentOffset
                }
                scrollView.contentOffset.y -= contentOffset
            }
        }
    }
}
