//
//  StepChallenge+CoreDataProperties.swift
//  5teps
//
//  Created by Fabio Palladino on 08/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//
//

import Foundation
import CoreData


extension StepChallenge {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StepChallenge> {
        return NSFetchRequest<StepChallenge>(entityName: "StepChallenge")
    }

    @NSManaged public var dateComplete: Date?
    @NSManaged public var dateEnd: Date?
    @NSManaged public var dateStart: Date?
    @NSManaged public var days: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var state: Int64
    @NSManaged public var step: Int64
    @NSManaged public var timestamp: Date?
    @NSManaged public var challenge: Challenge?

}
