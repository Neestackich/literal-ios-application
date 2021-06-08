//
//  CustomErrors.swift
//  Literal
//
//  Created by Neestackich on 27.01.21.
//

import Foundation

enum URLError: Error {
    case urlCreateError
}

extension URLError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .urlCreateError:
            return L10n.unableToCreateUrl
        }
    }
}

enum BackendError: Error {
    case incorrectCredentials
    case invalidCredentials
    case unauthorizedAccess
    case unknownError
}

extension BackendError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .incorrectCredentials:
            return L10n.incorrectEmailPassword
        case .invalidCredentials:
            return L10n.invalidEmailPassword
        case .unauthorizedAccess:
            return L10n.unauthorizedAccess
        case .unknownError:
            return L10n.unknownBackendError
        }
    }
}

enum NetworkError: Error {
    case noConnection
    case tooLongWaiting
    case badUrl
    case unknownError
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noConnection:
            return L10n.noConnection
        case .tooLongWaiting:
            return L10n.longResponse
        case .badUrl:
            return L10n.invalidUrl
        case .unknownError:
            return L10n.unknownNetworkError
        }
    }
}

enum DatabaseError: Error {
    case generalCoreDataError
    case saveError
    case openError
    case unknownError
}

extension DatabaseError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .generalCoreDataError:
            return L10n.databaseError
        case .openError:
            return L10n.databaseOpenError
        case .saveError:
            return L10n.databaseSaveError
        case .unknownError:
            return L10n.unknownDatabaseError
        }
    }
}
