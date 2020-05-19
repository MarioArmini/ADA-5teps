//
//  Challenge+Methods.swift
//  Test2
//
//  Created by Fabio Palladino on 02/05/2020.
//  Copyright © 2020 Fabio Palladino. All rights reserved.
//

import Foundation
import CoreData

public enum ChallengeState: Int64 {
    case Create = 0
    case Started = 1
    case Finished = 2
    case Abort = 3
}

extension Challenge {
    public static var DEFAULT_STEPS: Int64 = 5
    
    public func save() {
        _ = SharedInfo.context.safeSave()
    }
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
    var stepsOrder: [StepChallenge] {
        get  {
            let steps = self.steps?.allObjects as! [StepChallenge]
            return steps.sorted { (step1, step2) -> Bool in
                return step1.step < step2.step ? true : false
            }
        }
    }
    var deadLine: Date? {
        if isStart || isFinish {
            let steps = self.stepsOrder
            if steps.count > 0 {
                return steps[steps.count-1].dateComplete ?? steps[steps.count-1].dateEnd
            }
        }
        return nil
    }
    
    public static func list() -> [Challenge] {
        let context = SharedInfo.context
        let fetchRequest: NSFetchRequest<Challenge> = Challenge.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            print ("Error retrieving data")
        }
        return [Challenge]()
    }
    public static func listByState(state: ChallengeState) -> [Challenge] {
        let context = SharedInfo.context
        let fetchRequest: NSFetchRequest<Challenge> = Challenge.fetchRequest()
        //fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "dateEnd", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let filter = NSPredicate(format: "state == %i", state.rawValue)
        fetchRequest.predicate = filter
        
        do {
            
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            print ("Error retrieving data")
        }
        return [Challenge]()
    }
    public static func listInProgress() -> [Challenge] {
        let context = SharedInfo.context
        let fetchRequest: NSFetchRequest<Challenge> = Challenge.fetchRequest()
        //fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "dateEnd", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let filter = NSPredicate(format: "state == %i", ChallengeState.Started.rawValue)
        fetchRequest.predicate = filter
        
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
        if isCreate {
            self.dateStart = Date()
            self.dateLast = Date()
            self.currentStep = 0
            self.state = Int64(ChallengeState.Started.rawValue)
        }
        self.debugPrint()
        return nextStep()
    }
    public func debugPrint() {
        print("####################################")
        print(self.name ?? "", self.state, self.dateStart ?? "", self.deadLine ?? "", self.dateEnd ?? "")
        let steps = self.stepsOrder
        for i in steps {
            print(i.name ?? "", i.step, i.state, i.dateStart ?? "", i.dateEnd ?? "", i.dateComplete ?? "")
        }
        print("####################################")
    }
    public func nextStep() -> Bool
    {
        if self.numberSteps == self.currentStep {
            self.finish()
            return false
        }
        if let step = getCurrentStepChallenge() {
            step.finish()
        }
        self.currentStep = self.currentStep + 1
        
        //Se si tratta del primo step calcolo le deadline
        if self.currentStep == 1 {
            self.calculateDeadLine()
        }
        var updateDeadLine = false
        let steps = self.stepsOrder
        for i in steps {
            if i.step < self.currentStep {
                if(!i.isFinish) {
                    i.finish()
                    updateDeadLine = true
                }
            }else if i.step == self.currentStep {
                i.start()
            }
        }
        self.save()
        //Ricalcolo la deadline
        if updateDeadLine {
            self.calculateDeadLine()
        }
        return true
    }
    public func finish()
    {
        if !isFinish {
            self.dateEnd = Date()
            self.dateLast = Date()
            self.state = Int64(ChallengeState.Finished.rawValue)
            if let step = getCurrentStepChallenge() {
                step.finish()
            }
            
            self.save()
            //Salvo l'obiettivo raggiunto
            var level = Goal.getMaxLevel()
            if (level.count + 1) >= Goal.MAX_GOAL_CHANGE_LEVEL {
                level.level = level.level + 1
                level.count = 0
            }
            let goal = Goal(context: SharedInfo.context)
            goal.id = UUID()
            goal.date = Date()
            goal.level = Int16(level.level)
            goal.name = self.name
            goal.icon = Goal.findIconMedal(level: goal.level)
            goal.challenge = self
            goal.save()
        }
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
    public func calculateDeadLine() {
        let steps = self.stepsOrder
        if self.dateStart == nil {
            return
        }
        var dateBase = self.dateStart!
        for s in steps {
            if !s.isFinish {
                s.dateEnd = Calendar.current.date(byAdding: .day, value: Int(s.days), to: dateBase)
                s.save()
                
                dateBase = s.dateEnd!
            } else {
                dateBase = s.dateComplete ?? s.dateEnd!
            }
        }
    }
}

