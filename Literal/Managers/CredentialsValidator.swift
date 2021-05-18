//
//  CredentialsValidatorType.swift
//  iTechBook
//
//  Created by Neestackich on 30.11.20.
//

import Foundation

protocol CredentialsValidatorType {
    func areCredentialsValid(credentials: Credentials) -> Bool
}

final class CredentialsValidator: CredentialsValidatorType {
    func areCredentialsValid(credentials: Credentials) -> Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailCheckout = NSPredicate(format: "SELF MATCHES %@", emailPattern)

        return emailCheckout.evaluate(with: credentials.mail)
            && credentials.mail.count > 5
            && credentials.password.count > 10
    }
}
