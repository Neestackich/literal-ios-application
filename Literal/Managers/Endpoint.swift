//
//  Endpoint.swift
//  iTechBook
//
//  Created by Neestackich on 11.12.20.
//

import Foundation

enum EndpointMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum EndpointType {
    case login
    case users
    case books
    case ownBooks
    case showUser(Int)

    var value: String {
        switch self {
        case .login:
            return "/login"
        case .users:
            return "/users"
        case .books:
            return "/books/"
        case .ownBooks:
            return "/book/own_books"
        case .showUser(let id):
            return "/users/\(id)"
        }
    }
}

struct Endpoint<ResponseType: Decodable> {
    let path: EndpointType
    let method: EndpointMethod
    let isTokenRequired: Bool
    let body: Encodable?

    init(path: EndpointType,
         method: EndpointMethod,
         isTokenRequired: Bool,
         body: Encodable?) {
        self.path = path
        self.method = method
        self.isTokenRequired = isTokenRequired
        self.body = body
    }
}

extension Endpoint {
    static func login(with credentials: Credentials) -> Endpoint<LoginData> {
        return .init(
            path: .login,
            method: .post,
            isTokenRequired: false,
            body: credentials)
    }

    static func createAccount(with credentials: Credentials) -> Endpoint<CreateAccountData> {
        return .init(
            path: .users,
            method: .post,
            isTokenRequired: false,
            body: credentials
        )
    }

    static func getBooks() -> Endpoint<[Book]> {
        return .init(
            path: .books,
            method: .get,
            isTokenRequired: true,
            body: nil)
    }

    static func addBook(with bookData: BookData) -> Endpoint<Book> {
        return .init(
            path: .books,
            method: .post,
            isTokenRequired: true,
            body: bookData)
    }

    static func showUser(with id: Int) -> Endpoint<UserData> {
        return .init(
            path: .showUser(id),
            method: .get,
            isTokenRequired: true,
            body: nil)
    }

    static func getOwnBooks() -> Endpoint<[Book]> {
        return .init(
            path: .ownBooks,
            method: .get,
            isTokenRequired: true,
            body: nil)
    }
}
