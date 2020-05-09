//
//  Step+Methods.swift
//  Test2
//
//  Created by Fabio Palladino on 02/05/2020.
//  Copyright © 2020 Fabio Palladino. All rights reserved.
//

import Foundation
import CoreData

public enum StepChallengeState: Int64 {
    case Create = 0
    case Started = 1
    case Finished = 2
    case Abort = 3
}

extension StepChallenge {
    public func save() {
        _ = SharedInfo.context.safeSave()
    }
    public static func list() -> [StepChallenge] {
        let context = SharedInfo.context
        let fetchRequest: NSFetchRequest<StepChallenge> = StepChallenge.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            print ("Error retrieving data")
        }
        return [StepChallenge]()
    }
    public static func findByName(challengeName: String, name: String) -> StepChallenge? {
        if let challenge = Challenge.findByName(name: challengeName) {
            
            if let steps = challenge.steps?.filtered(using: NSPredicate(format: "name = %@", name)) {
                for s in steps {
                    return s as? StepChallenge
                }
            }
        }
        
        return nil
    }
    public static func findById(challengeId: String, stepId: String) -> StepChallenge? {
        if let challenge = Challenge.findById(id: challengeId) {
            
            if let steps = challenge.steps?.filtered(using: NSPredicate(format: "id = %@", stepId)) {
                for s in steps {
                    return s as? StepChallenge
                }
            }
        }
        
        return nil
    }
    public func start() {
        if self.state == Int64(StepChallengeState.Create.rawValue) {
            self.dateStart = Date()
            self.state = Int64(StepChallengeState.Started.rawValue)
        }
    }
    public func finish() {
        if self.state != Int64(StepChallengeState.Finished.rawValue) {
            self.dateEnd = Date()
            self.state = Int64(StepChallengeState.Finished.rawValue)
        }
    }
}
