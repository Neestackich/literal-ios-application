//
//  CoreDataBookStorage.swift
//  Literal
//
//  Created by Neestackich on 20.01.21.
//

import UIKit
import RxSwift
import RxCocoa
import CoreData

protocol BookStorageType {
    func getAllBooks(completion: @escaping (Result<[Book], Error>) -> Void)
    func getMyBooks(ownerId: Int, completion: @escaping (Result<[Book], Error>) -> Void)
    func saveBooks(books: [Book], completion: @escaping (Result<Void, Error>) -> Void)
}

extension BookStorageType {
    func getAllBooks() -> Single<[Book]> {
        return .create { observer in
            getAllBooks { completion in
                switch completion {
                case .success(let books):
                    observer(.success(books))
                case .failure(let error):
                    observer(.failure(error))
                }
            }

            return Disposables.create()
        }
    }

    func getMyBooks(ownerId: Int) -> Single<[Book]> {
        return .create { observer in
            getMyBooks(ownerId: ownerId) { completion in
                switch completion {
                case .success(let books):
                    observer(.success(books))
                case .failure(let error):
                    observer(.failure(error))
                }
            }

            return Disposables.create()
        }
    }

    func saveBooks(books: [Book]) -> Single<[Book]> {
        return .create { observer in
            saveBooks(books: books) { completion in
                switch completion {
                case .success:
                    observer(.success(books))
                case .failure(let error):
                    observer(.failure(error))
                }
            }

            return Disposables.create()
        }
    }
}

final class CoreDataBookStorage: BookStorageType {

    // MARK: - Properties

    private let context: NSManagedObjectContext

    // MARK: - Methods

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func getAllBooks(completion: @escaping (Result<[Book], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()

        context.perform {
            do {
                let coreDataBooks = try self.context.fetch(fetchRequest)
                var books = [Book]()

                coreDataBooks.forEach {
                    books.append(self.convert(bookEntity: $0))
                }

                completion(.success(books))
            } catch {
                let nsError = error as NSError

                completion(.failure(self.getDatabaseError(error: nsError)))
            }
        }
    }

    private func convert(bookEntity: BookEntity) -> Book {
        let id = Int(bookEntity.id)
        let name = String(bookEntity.name)
        let ownerId = Int(bookEntity.ownerId)
        let createdAt = bookEntity.createdAt
        let updatedAt = bookEntity.updatedAt
        let status = State(rawValue: bookEntity.status) ?? .inLibrary
        let deadLine = bookEntity.deadLine
        let readerUserId = Int(bookEntity.readerUserId)

        return .init(
            id: id,
            name: name,
            ownerId: ownerId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            status: status,
            deadLine: deadLine,
            readerUserId: readerUserId)
    }

    private func databaseCleanUp(completion: @escaping (Result<Void, Error>) -> Void) {
        context.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookEntity")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try self.context.execute(deleteRequest)

                completion(.success(()))
            } catch {
                let nsError = error as NSError

                completion(.failure(self.getDatabaseError(error: nsError)))
            }
        }
    }

    func getMyBooks(ownerId: Int, completion: @escaping (Result<[Book], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()

        context.perform {
            do {
                let coreDataBooks = try self.context.fetch(fetchRequest)
                var books = [Book]()

                coreDataBooks.forEach {
                    if $0.ownerId == ownerId {
                        books.append(self.convert(bookEntity: $0))
                    }
                }

                completion(.success(books))
            } catch {
                let nsError = error as NSError

                completion(.failure(self.getDatabaseError(error: nsError)))
            }
        }
    }

    func saveBooks(books: [Book], completion: @escaping (Result<Void, Error>) -> Void) {
        databaseCleanUp { response in
            switch response {
            case .success:
                self.context.perform {
                    books.forEach { book in
                        let newBook = NSEntityDescription.insertNewObject(
                            forEntityName: "BookEntity",
                            into: self.context) as! BookEntity
                        newBook.id = Int64(book.id)
                        newBook.name = book.name
                        newBook.ownerId = Int64(book.ownerId)
                        newBook.createdAt = book.createdAt
                        newBook.updatedAt = book.updatedAt
                        newBook.status = book.status.rawValue
                        newBook.deadLine = book.deadLine
                        newBook.readerUserId = Int64(book.readerUserId ?? 0)
                    }

                    do {
                        try self.context.save()

                        completion(.success(()))
                    } catch {
                        let nsError = error as NSError

                        completion(.failure(self.getDatabaseError(error: nsError)))
                    }
                }
            case .failure(let error):
                let nsError = error as NSError

                completion(.failure(self.getDatabaseError(error: nsError)))
            }
        }
    }

    private func getDatabaseError(error: NSError) -> Error {
        switch error.code {
        case 134060:
            return DatabaseError.generalCoreDataError
        case 134080:
            return DatabaseError.openError
        case 134040:
            return DatabaseError.saveError
        default:
            return DatabaseError.unknownError
        }
    }
}
