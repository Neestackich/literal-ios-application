//
//  MockCredentialsValidator.swift
//  iTechBookTests
//
//  Created by Neestackich on 11.02.21.
//

@testable import iTechBook

final class MockCredentialsValidator: CredentialsValidatorType {
    var credentialsValidationCalled = false

    func areCredentialsValid(credentials: Credentials) -> Bool {
        credentialsValidationCalled = true
        return credentialsValidationCalled
    }
}
