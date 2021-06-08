//
//  RequestsListViewController.swift
//  Literal
//
//  Created by Neestackich on 7.12.20.
//

import UIKit
import RxSwift
import RxCocoa

final class RequestsListViewController: UIViewController, UITableViewDelegate {

    // MARK: - Properties

    @IBOutlet private var stackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private var noDataStackView: UIStackView!
    @IBOutlet private var addBookButton: UIButton!
    @IBOutlet private var booksQuantityLabel: UILabel!
    @IBOutlet private var booksTableView: UITableView!
    @IBOutlet private var tableViewLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet private var booksQuantityStack: UIStackView!
    @IBOutlet private var booksQuantityInfoActivityIndicator: UIActivityIndicatorView!

    var viewModel: RequestsListViewModelType? {
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
        booksTableView.layer.cornerRadius = 38
        booksTableView.backgroundColor = .clear
        addBookButton.accessibilityIdentifier = "libraryAddButton"
        booksTableView.accessibilityIdentifier = "libraryTableView"
    }

    private func bindViewModel() {
        disposeBag = DisposeBag()

        if let viewModel = viewModel {
            let output = viewModel.transform(input: .init(
                addRequestButton: addBookButton.rx.tap.asDriver(),
                cellSelection: booksTableView.rx.modelSelected(Book.self).asDriver()))

            disposeBag.insert(
                output.requestsQuantity.drive(booksQuantityLabel.rx.text),
                output.isLoading.drive(tableViewLoadingIndicator.rx.isAnimating,
                                       booksQuantityInfoActivityIndicator.rx.isAnimating,
                                       booksTableView.rx.isHidden,
                                       booksQuantityStack.rx.isHidden),
                output.requests.drive(booksTableView.rx.items(
                        cellIdentifier: "LibraryTableViewCell",
                        cellType: RequestTableViewCell.self)) { _, book, cell in
                            cell.viewModel = BookViewModel(book: book)
                            cell.accessibilityIdentifier = "LibraryTableViewCell"
                        },
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
