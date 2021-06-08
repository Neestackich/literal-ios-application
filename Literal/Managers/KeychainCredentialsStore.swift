//
//  KeychainCredentialsStore.swift
//  Literal
//
//  Created by Neestackich on 14.01.21.
//

import Foundation
import SwiftKeychainWrapper

struct UserCredentials {
    let token: Token
    let username: String
}

protocol CredentialsStore {
    var credentials: UserCredentials? { get set }
}

final class KeychainCredentialsStore: CredentialsStore {

    // MARK: - Properties

    private let userTokenKey = "userToken"
    private let username = "username"

    private let keychain: KeychainWrapper

    var credentials: UserCredentials? {
        get {
            let retrievedToken = keychain.string(forKey: userTokenKey)
            let retrievedUsername = keychain.string(forKey: username)

            guard let token = retrievedToken,
                  let username = retrievedUsername else {
                print("No credentials data")

                return nil
            }

            return .init(token: token, username: username)
        }
        set {
            guard let value = newValue else {
                keychain.removeAllKeys()
                print("Credentials deleted")

                return
            }

            keychain.set(value.token, forKey: userTokenKey)
            keychain.set(value.username, forKey: username)

            print("Credentials saved")
        }
    }

    // MARK: - Methods

    init(keychain: KeychainWrapper = KeychainWrapper.standard) {
        self.keychain = keychain
    }
}
