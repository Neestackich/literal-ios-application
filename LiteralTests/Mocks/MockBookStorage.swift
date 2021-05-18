//
//  MockCoreDataBookStorage.swift
//  iTechBookTests
//
//  Created by Neestackich on 15.02.21.
//

@testable import iTechBook
import Foundation

final class MockCoreDataBookStorage: BookStorageType {
    var getAllBooksCalled = false
    var saveBooksCalled = false
    var getMyBooksCalled = false
    private let dummyBooksData = [Book(
                            id: 0,
                            name: "Dummy book",
                            ownerId: 0,
                            createdAt: Date(),
                            updatedAt: Date(),
                            status: .inLibrary,
                            deadLine: nil,
                            readerUserId: nil),
                            Book(
                            id: 0,
                            name: "Dummy book",
                            ownerId: 0,
                            createdAt: Date(),
                            updatedAt: Date(),
                            status: .inLibrary,
                            deadLine: nil,
                            readerUserId: nil)]

    func getAllBooks(completion: @escaping (Result<[Book], Error>) -> Void) {
        getAllBooksCalled = true
        completion(.success(dummyBooksData))
    }

    func saveBooks(books: [Book], completion: @escaping (Result<Void, Error>) -> Void) {
        saveBooksCalled = true
        completion(.success(()))
    }

    func getMyBooks(ownerId: Int, completion: @escaping (Result<[Book], Error>) -> Void) {
        getMyBooksCalled = true
        completion(.success(dummyBooksData))
    }
}
