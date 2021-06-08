//
//  APIClient.swift
//  Literal
//
//  Created by Neestackich on 25.11.20.
//

// http://Neestackich.local:8000/api/v1/authentication/login/

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

struct ErrorResponse {
    let message: String
}

struct BackendErrorType: Decodable {
    let mail: [String]
}

struct CreateAccountData: Decodable {
    let id: Int
    let mail: String
    let token: Token
}

struct LoginResponce: Decodable {
    let username: String
    let token: String
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

struct RegistrationCredentials: Encodable {
    let email: String
    let password: String
    let username: String
}

struct LoginCredentials: Encodable {
    let username: String
    let password: String
}

struct ImageData: Encodable {
    let image: Data?
}

struct UserData: Decodable {
    let token: String
    let username: String
}

protocol APIClientType {
    func request<T: Decodable>(endpoint: Endpoint<T>) -> Single<T>
}

extension NSMutableData {
  func append(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}

final class APIClient: APIClientType {

    // MARK: - Properties

    private let urlPrefix = "http://Neestackich.local:8000/api/v1/"
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

        if endpoint.imageUpload, let body = endpoint.body as? ImageData, let image = body.image {

            let parameters = [
              [
                "key": "image",
                "src": "image.jpeg",
                "type": "file"
              ]] as [[String : Any]]

            let boundary = "Boundary-\(UUID().uuidString)"
            var body = ""

            for param in parameters {
                if param["disabled"] == nil {
                    let paramName = param["key"]!
                    body += "--\(boundary)\r\n"
                    body += "Content-Disposition:form-data; name=\"\(paramName)\""
                    if param["contentType"] != nil {
                        body += "\r\nContent-Type: \(param["contentType"] as! String)"
                    }

                    let paramType = param["type"] as! String

                    if paramType == "text" {
                        let paramValue = param["value"] as! String
                        body += "\r\n\r\n\(paramValue)\r\n"
                    } else {
                        let paramSrc = param["src"] as! String

                        let imageItself = UIImage(data: image)
                        let imageData = imageItself!.jpegData(compressionQuality: 0)
                        let base64 = (imageData?.base64EncodedData(options: .ArrayLiteralElement()))!
                        let encoded = String(data: base64, encoding: .utf8)!
                        print(encoded.replacingOccurrences(of: " ", with: ""))
                        body += "; filename=\"\(paramSrc)\"\r\n"
                            + "Content-Type: img/jpeg\r\n header\"\r\n\r\n\(encoded.replacingOccurrences(of: " ", with: ""))\r\n"
                    }
                }
            }

            body += "--\(boundary)--\r\n"
            let postData = body.data(using: .utf8)

            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = postData
 
        } else {
            request.httpBody = endpoint.body?.toSJONData()
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        if endpoint.isTokenRequired, let userToken = credentialsStore.credentials?.token {
            request.addValue("Token \(userToken)", forHTTPHeaderField: "Authorization")
        }

        return request
    }

    struct MultipartFormDataRequest {
        private let boundary: String = UUID().uuidString
        private var httpBody = NSMutableData()
        let url: URL

        init(url: URL) {
            self.url = url
        }

        func addTextField(named name: String, value: String) {
            httpBody.append(textFormField(named: name, value: value))
        }

        private func textFormField(named name: String, value: String) -> String {
            var fieldString = "--\(boundary)\r\n"
            fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
            fieldString += "Content-Type: text/plain; charset=ISO-8859-1\r\n"
            fieldString += "Content-Transfer-Encoding: 8bit\r\n"
            fieldString += "\r\n"
            fieldString += "\(value)\r\n"

            return fieldString
        }

        func addDataField(named name: String, data: Data, mimeType: String) {
            httpBody.append(dataFormField(named: name, data: data, mimeType: mimeType))
        }

        func asURLRequest() -> URLRequest {
            var request = URLRequest(url: url)

            request.httpMethod = "POST"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            httpBody.append("--\(boundary)--")
            request.httpBody = httpBody as Data
            return request
        }

        private func dataFormField(named name: String, data: Data, mimeType: String) -> Data {
            let fieldData = NSMutableData()

            fieldData.append("--\(boundary)\r\n")
            fieldData.append("Content-Disposition: form-data; name=\"\(name)\"\r\n")
            fieldData.append("Content-Type: \(mimeType)\r\n")
            fieldData.append("\r\n")
            fieldData.append(data)
            fieldData.append("\r\n")

            return fieldData as Data
        }
    }

    func request<T: Decodable>(endpoint: Endpoint<T>) -> Single<T> {
         return Single<T>.create { observer in
            do {
                let request = try self.setupRequest(endpoint: endpoint)
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    if let error = error {
                        let nsError = error as NSError
                        observer(.failure(self.getNetworkError(error: nsError)))
                    } else if let data = data {
                        do {
                            let parsedData = try self.decoder.decode(T.self, from: data)
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
