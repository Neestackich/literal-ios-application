//
//  APIClient.swift
//  iTechBook
//
//  Created by Neestackich on 25.11.20.
//

import UIKit
import RxSwift
import RxCocoa

typealias Token = String

extension Encodable {
    func toSJONData() -> Data? {
        try? JSONEncoder().encode(self)
    }
}

struct Response<DataType: Decodable>: Decodable {
    let code: Int
    let status: String
    let data: DataType
}

struct BackendErrorType: Decodable {
    let mail: [String]
}

struct CreateAccountData: Decodable {
    let id: Int
    let mail: String
    let token: Token
}

struct LoginData: Decodable {
    let id: Int
    let mail: String
    let createdAt: Date
    let updatedAt: Date
    let token: Token
    let password: String

    enum CodingKeys: String, CodingKey {
        case id
        case mail
        case token
        case password
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

enum State: String, Decodable {
    case pickedUp = "picked_up"
    case reserved = "reserved"
    case inLibrary = "in_library"

    var readableName: String {
        switch self {
        case .pickedUp:
            return L10n.pickedUpState
        case .reserved:
            return L10n.reservedState
        case .inLibrary:
            return L10n.inLibraryState
        }
    }
}

struct Book: Decodable {
    let id: Int
    let name: String
    let ownerId: Int
    let createdAt: Date
    let updatedAt: Date
    let status: State
    let deadLine: Date?
    let readerUserId: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case ownerId = "owner_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case status
        case deadLine = "dead_line"
        case readerUserId = "reader_user_id"
    }

    init(id: Int,
         name: String,
         ownerId: Int,
         createdAt: Date,
         updatedAt: Date,
         status: State,
         deadLine: Date?,
         readerUserId: Int?) {
        self.id = id
        self.name = name
        self.ownerId = ownerId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.status = status
        self.deadLine = deadLine
        self.readerUserId = readerUserId
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.ownerId = try container.decode(Int.self, forKey: .ownerId)
        self.createdAt = try container.decode(Date.self, forKey: .updatedAt)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        self.status = try container.decode(State.self, forKey: .status)

        let deadLineString = try container.decode(String?.self, forKey: .deadLine)

        if let deadLineString = deadLineString {
            let dateFormatter = DateFormatter.YYYYMMDD
            let deadLine = dateFormatter.date(from: deadLineString)
            self.deadLine = deadLine
        } else {
            self.deadLine = nil
        }

        self.readerUserId = try container.decode(Int?.self, forKey: .readerUserId)
    }
}

struct Credentials: Encodable {
    let mail: String
    let password: String
}

struct BookData: Encodable {
    let name: String
}

struct UserData: Decodable {
    let id: Int
    let mail: String
}

protocol APIClientType {
    func request<T: Decodable>(endpoint: Endpoint<T>) -> Single<Response<T>>
}

final class APIClient: APIClientType {

    // MARK: - Properties

    private let urlPrefix = "https://powerful-citadel-31931.herokuapp.com/api/v1"
    private let decoder: JSONDecoder
    private let credentialsStore: CredentialsStore

    // MARK: - Methods

    init(decoder: JSONDecoder, credentialsStore: CredentialsStore) {
        self.decoder = decoder
        self.decoder.dateDecodingStrategy = .formatted(.iso8601Full)
        self.credentialsStore = credentialsStore
    }

    private func setupRequest<Response: Decodable>(endpoint: Endpoint<Response>) throws -> URLRequest {
        let urlString = urlPrefix + endpoint.path.value

        guard let url = URL(string: urlString) else {
            throw URLError.urlCreateError
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body?.toSJONData()
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if endpoint.isTokenRequired, let userToken = credentialsStore.credentials?.token {
            request.addValue("Bearer \(userToken)", forHTTPHeaderField: "Authorization")
        }

        return request
    }

    func request<T: Decodable>(endpoint: Endpoint<T>) -> Single<Response<T>> {
         return Single<Response<T>>.create { observer in
            do {
                let request = try self.setupRequest(endpoint: endpoint)
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    if let error = error {
                        let nsError = error as NSError

                        observer(.failure(self.getNetworkError(error: nsError)))
                    } else if let data = data {
                        do {
                            let parsedData = try self.decoder.decode(Response<T>.self, from: data)

                            observer(.success(parsedData))
                        } catch {
                            let nsError = error as NSError

                            observer(.failure(self.getBackendError(error: nsError)))
                        }
                    }
                }
                task.resume()

                return Disposables.create {
                    task.cancel()
                }
            } catch {
                observer(.failure(URLError.urlCreateError))
            }

            return Disposables.create()
         }
    }

    private func getBackendError(error: NSError) -> Error {
        switch error.code {
        case 4864:
            return BackendError.incorrectCredentials
        case 4865:
            return BackendError.invalidCredentials
        default:
            return BackendError.unknownError
        }
    }

    private func getNetworkError(error: NSError) -> Error {
        switch error.code {
        case -1009, -1005, -1020:
            return NetworkError.noConnection
        case -1001:
            return NetworkError.tooLongWaiting
        case -1000:
            return NetworkError.badUrl
        default:
            return NetworkError.unknownError
        }
    }
}
