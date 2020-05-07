//
//  Challenge+CoreDataProperties.swift
//  Test2
//
//  Created by Fabio Palladino on 07/05/2020.
//  Copyright © 2020 Fabio Palladino. All rights reserved.
//
//

import Foundation
import CoreData


extension Challenge {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Challenge> {
        return NSFetchRequest<Challenge>(entityName: "Challenge")
    }

    @NSManaged public var currentStep: Int64
    @NSManaged public var dateEnd: Date?
    @NSManaged public var dateLast: Date?
    @NSManaged public var dateStart: Date?
    @NSManaged public var name: String?
    @NSManaged public var numberSteps: Int64
    @NSManaged public var state: Int64
    @NSManaged public var timestamp: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var steps: NSSet?
    @NSManaged public var topic: Topic?

}

// MARK: Generated accessors for steps
extension Challenge {

    @objc(addStepsObject:)
    @NSManaged public func addToSteps(_ value: StepChallenge)

    @objc(removeStepsObject:)
    @NSManaged public func removeFromSteps(_ value: StepChallenge)

    @objc(addSteps:)
    @NSManaged public func addToSteps(_ values: NSSet)

    @objc(removeSteps:)
    @NSManaged public func removeFromSteps(_ values: NSSet)

}
