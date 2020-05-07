//
//  Challenge+Methods.swift
//  Test2
//
//  Created by Fabio Palladino on 02/05/2020.
//  Copyright © 2020 Fabio Palladino. All rights reserved.
//

import Foundation
import CoreData

enum ChallengeState: Int64 {
    case Create = 0
    case Started = 1
    case Finished = 2
    case Abort = 3
}

extension Challenge {
    public static var DEFAULT_STEPS: Int64 = 5
    
    //MARK: Custom Property
    var enumState: ChallengeState {
        get {
            return ChallengeState(rawValue: self.state)!
        }
    }
    var isStart: Bool {
        get {
            return (enumState == ChallengeState.Started) ? true : false
        }
    }
    var isFinish: Bool {
        get {
            return (enumState == ChallengeState.Finished) ? true : false
        }
    }
    var isAbort: Bool {
        get {
            return (enumState == ChallengeState.Abort) ? true : false
        }
    }
    var isCreate: Bool {
        get {
            return (enumState == ChallengeState.Create) ? true : false
        }
    }
    
    public static func list() -> [Challenge] {
        let context = SharedInfo.context
        let fetchRequest: NSFetchRequest<Challenge> = Challenge.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            print ("Error retrieving data")
        }
        return [Challenge]()
    }
    public static func findByName(name: String) -> Challenge? {
        let context = SharedInfo.context
        let fetchRequest: NSFetchRequest<Challenge> = Challenge.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let filter = NSPredicate(format: "name == %@", name)
        fetchRequest.predicate = filter
        do {
            
            let result = try context.fetch(fetchRequest)
            if result.count > 0 {
                return result[0]
            }
        } catch {
            print ("Error retrieving data")
        }
        return nil
    }
    public static func findById(id: String) -> Challenge? {
        let context = SharedInfo.context
        let fetchRequest: NSFetchRequest<Challenge> = Challenge.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        
        let filter = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = filter
        do {
            
            let result = try context.fetch(fetchRequest)
            if result.count > 0 {
                return result[0]
            }
        } catch {
            print ("Error retrieving data")
        }
        return nil
    }
    public func delete() {
        let context = SharedInfo.context
        context.delete(self)
        _ = context.safeSave()
    }
    public func start() -> Bool {
        self.dateStart = Date()
        self.dateLast = Date()
        self.currentStep = 0
        self.state = Int64(ChallengeState.Started.rawValue)
       
        return nextStep()
    }
    public func nextStep() -> Bool
    {
        let context = SharedInfo.context
        if self.numberSteps == self.currentStep {
            self.finish()
            return false
        }
        if let step = getCurrentStepChallenge() {
            step.finish()
        }
        self.currentStep = self.currentStep + 1
        let steps = self.steps?.allObjects as! [StepChallenge]
        for i in steps {
            if i.step < self.currentStep {
                i.finish()
            }else if i.step == self.currentStep {
                i.start()
            }
        }
        return context.safeSave()
    }
    public func finish()
    {
        let context = SharedInfo.context
        self.dateEnd = Date()
        self.dateLast = Date()
        self.state = Int64(ChallengeState.Finished.rawValue)
        if let step = getCurrentStepChallenge() {
            step.finish()
        }
        
        _ = context.safeSave()
    }
    public func getCurrentStepChallenge() -> StepChallenge? {
        if self.isStart {
            let steps = self.steps?.allObjects as! [StepChallenge]
            for i in steps {
                if i.step == self.currentStep {
                    return i
                }
            }
        }
        return nil
    }
}

