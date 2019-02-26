//
//  Document+CoreDataProperties.swift
//  Documents Core Data Relationships
//
//  Created by Brock Gibson on 2/25/19.
//  Copyright © 2019 Brock Gibson. All rights reserved.
//
//

import Foundation
import CoreData


extension Document {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Document> {
        return NSFetchRequest<Document>(entityName: "Document")
    }

    @NSManaged public var name: String?
    @NSManaged public var rawDate: NSDate?
    @NSManaged public var size: Int64
    @NSManaged public var content: String?
    @NSManaged public var category: Category?

}
