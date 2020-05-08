//
//  Topic+CoreDataProperties.swift
//  5teps
//
//  Created by Fabio Palladino on 08/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//
//

import Foundation
import CoreData


extension Topic {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Topic> {
        return NSFetchRequest<Topic>(entityName: "Topic")
    }

    @NSManaged public var active: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var challanges: NSSet?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for challanges
extension Topic {

    @objc(addChallangesObject:)
    @NSManaged public func addToChallanges(_ value: Challenge)

    @objc(removeChallangesObject:)
    @NSManaged public func removeFromChallanges(_ value: Challenge)

    @objc(addChallanges:)
    @NSManaged public func addToChallanges(_ values: NSSet)

    @objc(removeChallanges:)
    @NSManaged public func removeFromChallanges(_ values: NSSet)

}
