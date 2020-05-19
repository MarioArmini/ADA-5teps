//
//  Goal+CoreDataProperties.swift
//  5teps
//
//  Created by Fabio Palladino on 08/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//
//

import Foundation
import CoreData


extension Goal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var icon: String?
    @NSManaged public var level: Int16
    @NSManaged public var name: String?
    @NSManaged public var challenge: Challenge?

}
