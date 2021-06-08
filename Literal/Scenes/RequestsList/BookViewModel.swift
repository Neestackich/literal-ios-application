//
//  BookViewModel.swift
//  Literal
//
//  Created by Neestackich on 10.12.20.
//

import UIKit
import RxSwift
import RxCocoa

protocol BookViewModelType {
    var bookName: String { get }
    var bookStatus: String { get }
}

struct BookViewModel: BookViewModelType {
    let book: Book
    var bookName: String { book.name }
    var bookStatus: String { book.status.readableName }
}
