//
//  KeychainCredentialsStore.swift
//  iTechBook
//
//  Created by Neestackich on 14.01.21.
//

import Foundation
import SwiftKeychainWrapper

struct UserCredentials {
    let token: Token
    let id: Int
    let email: String
}

protocol CredentialsStore {
    var credentials: UserCredentials? { get set }
}

final class KeychainCredentialsStore: CredentialsStore {

    // MARK: - Properties

    private let userIDKey = "userID"
    private let userTokenKey = "userToken"
    private let userEmail = "userEmail"

    private let keychain: KeychainWrapper

    var credentials: UserCredentials? {
        get {
            let retrievedId = keychain.integer(forKey: userIDKey)
            let retrievedToken = keychain.string(forKey: userTokenKey)
            let retrievedEmail = keychain.string(forKey: userEmail)

            guard let token = retrievedToken,
                  let id = retrievedId,
                  let email = retrievedEmail else {
                print("No credentials data")

                return nil
            }

            return .init(token: token, id: id, email: email)
        }
        set {
            guard let value = newValue else {
                keychain.removeAllKeys()
                print("Credentials deleted")

                return
            }

            keychain.set(value.id, forKey: userIDKey)
            keychain.set(value.token, forKey: userTokenKey)
            keychain.set(value.email, forKey: userEmail)

            print("Credentials saved")
        }
    }

    // MARK: - Methods

    init(keychain: KeychainWrapper = KeychainWrapper.standard) {
        self.keychain = keychain
    }
}
