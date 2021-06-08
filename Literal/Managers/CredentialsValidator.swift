//
//  CredentialsValidatorType.swift
//  Literal
//
//  Created by Neestackich on 30.11.20.
//

import Foundation

protocol CredentialsValidatorType {
    func areCredentialsValid(credentials: RegistrationCredentials) -> Bool
    func areCredentialsValid(credentials: LoginCredentials) -> Bool
}

final class CredentialsValidator: CredentialsValidatorType {

    func areCredentialsValid(credentials: RegistrationCredentials) -> Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailCheckout = NSPredicate(format: "SELF MATCHES %@", emailPattern)
        let usernamePattern = "[a-zA-Z0-9]+"
        let usernameCheckout = NSPredicate(format: "SELF MATCHES %@", usernamePattern)

        return emailCheckout.evaluate(with: credentials.email)
            && credentials.email.count > 1
            && credentials.password.count > 10
    }

    func areCredentialsValid(credentials: LoginCredentials) -> Bool {
        let usernamePattern = "[a-zA-Z0-9]+"
        let usernameCheckout = NSPredicate(format: "SELF MATCHES %@", usernamePattern)

        return usernameCheckout.evaluate(with: credentials.username)
            && credentials.username.count > 1
            && credentials.password.count > 10
    }
}
