//
//  Endpoint.swift
//  Literal
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
    case createAccount
    case scanRequest
    case users
    case books
    case ownBooks
    case showUser(Int)

    var value: String {
        switch self {
        case .login:
            return "authentication/login/"
        case .createAccount:
            return "authentication/register/"
        case .scanRequest:
            return "order/"
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
    let imageUpload: Bool

    init(path: EndpointType,
         method: EndpointMethod,
         isTokenRequired: Bool,
         body: Encodable?,
         imageUpload: Bool = false) {
        self.path = path
        self.method = method
        self.isTokenRequired = isTokenRequired
        self.body = body
        self.imageUpload = imageUpload
    }
}

extension Endpoint {
    static func login(with credentials: LoginCredentials) -> Endpoint<LoginResponce> {
        return .init(
            path: .login,
            method: .post,
            isTokenRequired: false,
            body: credentials)
    }

    static func createAccount(with credentials: RegistrationCredentials) -> Endpoint<LoginResponce> {
        return .init(
            path: .createAccount,
            method: .post,
            isTokenRequired: false,
            body: credentials
        )
    }

    static func getRequests() -> Endpoint<[Book]> {
        return .init(
            path: .books,
            method: .get,
            isTokenRequired: true,
            body: nil)
    }

    static func addRequest(with imageData: ImageData) -> Endpoint<Book> {
        return .init(
            path: .scanRequest,
            method: .post,
            isTokenRequired: true,
            body: imageData,
            imageUpload: true)
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
