//
//  BookEntity+CoreDataClass.swift
//  
//
//  Created by Neestackich on 25.01.21.
//
//

import UIKit
import CoreData

@objc(BookEntity)
public class BookEntity: NSManagedObject {

    @NSManaged var id: Int64
    @NSManaged var name: String
    @NSManaged var ownerId: Int64
    @NSManaged var createdAt: Date
    @NSManaged var status: String
    @NSManaged var updatedAt: Date
    @NSManaged var deadLine: Date?
    @NSManaged var readerUserId: Int64

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookEntity> {
        return NSFetchRequest<BookEntity>(entityName: "BookEntity")
    }
}
