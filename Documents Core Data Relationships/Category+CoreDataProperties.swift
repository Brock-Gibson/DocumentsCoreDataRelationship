//
//  Category+CoreDataProperties.swift
//  Documents Core Data Relationships
//
//  Created by Brock Gibson on 2/25/19.
//  Copyright © 2019 Brock Gibson. All rights reserved.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var title: String?
    @NSManaged public var rawDocuments: NSOrderedSet?

}

// MARK: Generated accessors for rawDocuments
extension Category {

    @objc(insertObject:inRawDocumentsAtIndex:)
    @NSManaged public func insertIntoRawDocuments(_ value: Document, at idx: Int)

    @objc(removeObjectFromRawDocumentsAtIndex:)
    @NSManaged public func removeFromRawDocuments(at idx: Int)

    @objc(insertRawDocuments:atIndexes:)
    @NSManaged public func insertIntoRawDocuments(_ values: [Document], at indexes: NSIndexSet)

    @objc(removeRawDocumentsAtIndexes:)
    @NSManaged public func removeFromRawDocuments(at indexes: NSIndexSet)

    @objc(replaceObjectInRawDocumentsAtIndex:withObject:)
    @NSManaged public func replaceRawDocuments(at idx: Int, with value: Document)

    @objc(replaceRawDocumentsAtIndexes:withRawDocuments:)
    @NSManaged public func replaceRawDocuments(at indexes: NSIndexSet, with values: [Document])

    @objc(addRawDocumentsObject:)
    @NSManaged public func addToRawDocuments(_ value: Document)

    @objc(removeRawDocumentsObject:)
    @NSManaged public func removeFromRawDocuments(_ value: Document)

    @objc(addRawDocuments:)
    @NSManaged public func addToRawDocuments(_ values: NSOrderedSet)

    @objc(removeRawDocuments:)
    @NSManaged public func removeFromRawDocuments(_ values: NSOrderedSet)

}
