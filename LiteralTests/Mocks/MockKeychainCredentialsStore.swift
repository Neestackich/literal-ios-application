//
//  MockKeychainCredentialsStore.swift
//  iTechBookTests
//
//  Created by Neestackich on 11.02.21.
//

@testable import iTechBook

final class MockKeychainCredentialsStore: CredentialsStore {
    var credentialsRequested = false
    var credentialsSetted = false
    var dummyToken = "DummyToken"
    var dummyId = 1
    var dummyEmail = "DummyEmail"

    var credentials: UserCredentials? {
        get {
            credentialsRequested = true
            return .init(token: dummyToken, id: dummyId, email: dummyEmail)
        }
        set {
            credentialsSetted = true
            if let newValue = newValue {
                dummyToken = newValue.token
                dummyId = newValue.id
                dummyEmail = newValue.email
            }
        }
    }
}
