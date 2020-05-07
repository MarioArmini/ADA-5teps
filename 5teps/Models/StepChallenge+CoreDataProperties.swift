//
//  StepChallenge+CoreDataProperties.swift
//  Test2
//
//  Created by Fabio Palladino on 07/05/2020.
//  Copyright © 2020 Fabio Palladino. All rights reserved.
//
//

import Foundation
import CoreData


extension StepChallenge {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StepChallenge> {
        return NSFetchRequest<StepChallenge>(entityName: "StepChallenge")
    }

    @NSManaged public var dateEnd: Date?
    @NSManaged public var dateStart: Date?
    @NSManaged public var name: String?
    @NSManaged public var state: Int64
    @NSManaged public var step: Int64
    @NSManaged public var timestamp: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var days: Int16
    @NSManaged public var challenge: Challenge?

}
