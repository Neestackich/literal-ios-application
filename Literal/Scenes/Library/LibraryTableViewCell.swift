//
//  LibraryTableViewCell.swift
//  iTechBook
//
//  Created by Neestackich on 8.12.20.
//

import UIKit
import RxSwift
import RxCocoa

final class LibraryTableViewCell: UITableViewCell {

    // MARK: - Properties

    @IBOutlet private var bookImage: UIImageView!
    @IBOutlet private var bookName: UILabel!
    @IBOutlet private var bookAuthor: UILabel!
    @IBOutlet private var bookStatus: UILabel!
    @IBOutlet private var mainContentView: UIView!

    var viewModel: BookViewModel? {
        didSet {
            bookName.text = viewModel?.bookName
            bookStatus.text = viewModel?.bookStatus

            switch bookStatus.text {
            case State.inLibrary.readableName:
                bookStatus.textColor = UIColor(
                    red: 28/255,
                    green: 144/255,
                    blue: 51/255,
                    alpha: 0.8)
            case State.pickedUp.readableName:
                bookStatus.textColor = UIColor(
                    red: 168/255,
                    green: 51/255,
                    blue: 35/255,
                    alpha: 0.8)
            case State.reserved.readableName:
                bookStatus.textColor = UIColor(
                    red: 169/255,
                    green: 156/255,
                    blue: 11/255,
                    alpha: 0.8)
            default:
                break
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    private func setup() {
        mainContentView.layer.cornerRadius = 30
    }
}
