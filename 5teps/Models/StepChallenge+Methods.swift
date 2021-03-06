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
    //MARK: Custom Property
    var enumState: StepChallengeState {
        get {
            return StepChallengeState(rawValue: self.state)!
        }
    }
    var isStart: Bool {
        get {
            return (enumState == StepChallengeState.Started) ? true : false
        }
    }
    var isFinish: Bool {
        get {
            return (enumState == StepChallengeState.Finished) ? true : false
        }
    }
    var isAbort: Bool {
        get {
            return (enumState == StepChallengeState.Abort) ? true : false
        }
    }
    var isCreate: Bool {
        get {
            return (enumState == StepChallengeState.Create) ? true : false
        }
    }
    
    public static func list() -> [StepChallenge] {
        let context = SharedInfo.context
        let fetchRequest: NSFetchRequest<StepChallenge> = StepChallenge.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
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
        if isCreate {
            self.dateStart = Date()
            self.state = Int64(StepChallengeState.Started.rawValue)
        }
    }
    public func finish() {
        if isStart {
            self.dateEnd = Date()
            self.dateComplete = Date()
            self.state = Int64(StepChallengeState.Finished.rawValue)
        }
    }
    public func daysToDeadline() -> Int {
        if let d = self.dateEnd {
            let dNow = Date()
            var diffInDays = Calendar.current.dateComponents([.day], from: dNow, to: d).day ?? 0
            var hours = Calendar.current.dateComponents([.hour], from: dNow, to: d).hour ?? 0
            hours = hours % 24
            if hours > 12 {
                diffInDays = diffInDays + 1
            }
            return diffInDays
        }
        return 0
    }
}
