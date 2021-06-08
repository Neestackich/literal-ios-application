//
//  DependencyResolver.swift
//  Literal
//
//  Created by Neestackich on 18.01.21.
//

import UIKit
import CoreData

final class DependencyResolver {
    static let shared = DependencyResolver()

    var keychain: CredentialsStore
    let apiClient: APIClientType
    let validator: CredentialsValidatorType
    let database: BookStorageType

    private init() {
        self.keychain = KeychainCredentialsStore()
        self.apiClient = APIClient(
            decoder: JSONDecoder(),
            credentialsStore: self.keychain)
        self.validator = CredentialsValidator()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        self.database = CoreDataBookStorage(context: context)
    }
}
