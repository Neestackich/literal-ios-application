//
//  MockAPIClient.swift
//  iTechBookTests
//
//  Created by Neestackich on 11.02.21.
//

@testable import iTechBook
import RxSwift

final class MockAPIClient: APIClientType {
    var requestCalled = false
    private let dummyBookData = Book(
                            id: 0,
                            name: "Dummy book",
                            ownerId: 0,
                            createdAt: Date(),
                            updatedAt: Date(),
                            status: .inLibrary,
                            deadLine: nil,
                            readerUserId: nil)
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
    private let dummyUserData = UserData(id: 0, mail: "Dummy email")
    private let dummyAccountData = CreateAccountData(id: 0,
                                             mail: "Dummy email",
                                             token: "Dummy token")
    private let dummyLoginData = LoginData(
        id: 0,
        mail: "Dummy email",
        createdAt: Date(),
        updatedAt: Date(),
        token: "Dummy token",
        password: "Dummy password")

    func request<T>(endpoint: Endpoint<T>) -> Single<Response<T>> where T: Decodable {
        requestCalled = true

        return Single<Response<T>>.create { observer in
            switch endpoint.path {
            case .ownBooks:
                observer(.success(Response(
                                    code: 0,
                                    status: "Dummy status",
                                    data: self.dummyBooksData as! T)))
            case .books:
                if T.self == [Book].self {
                    observer(.success(Response(
                                    code: 0,
                                    status: "Dummy status",
                                    data: self.dummyBooksData as! T)))
                } else {
                    observer(.success(Response(
                                    code: 0,
                                    status: "Dummy status",
                                    data: self.dummyBookData as! T)))
                }
            case .login:
                observer(.success(Response(
                                    code: 0,
                                    status: "Dummy status",
                                    data: self.dummyLoginData as! T)))
            case .users:
                observer(.success(Response(
                                    code: 0,
                                    status: "Dummy status",
                                    data: self.dummyAccountData as! T)))
            default:
                break
             }

            return Disposables.create()
        }
    }
}
