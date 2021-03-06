//
//  Topic+Methods.swift
//  Test2
//
//  Created by Fabio Palladino on 02/05/2020.
//  Copyright © 2020 Fabio Palladino. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension Topic {
    
    var bgColor: UIColor {
        get {
            if let color = self.color {
                return Utils.hexStringToUIColor(hex: color)
            }
            return UIColor.white
        }
    }
    var colorCard: ColorCard {
        get {
            if let color = self.color {
                return  ColorCard.findColor(color: color)
            }
            return ColorCard.defaultColor
        }
    }
    
    public static func list() -> [Topic] {
        let context = SharedInfo.context
        let fetchRequest: NSFetchRequest<Topic> = Topic.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let filter = NSPredicate(format: "active == %@", NSNumber(value: true))
        fetchRequest.predicate = filter
        
        do {
            
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            print ("Error retrieving data")
        }
        return [Topic]()
    }
    public static func findByName(name: String) -> Topic? {
        let context = SharedInfo.context
        let fetchRequest: NSFetchRequest<Topic> = Topic.fetchRequest()
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
    public static func findById(id: String) -> Topic? {
        let context = SharedInfo.context
        let fetchRequest: NSFetchRequest<Topic> = Topic.fetchRequest()
        fetchRequest.fetchBatchSize = 1
        
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
    public func findChallengeByName(name: String) -> Challenge? {
        if let result = self.challanges?.filtered(using: NSPredicate(format: "name = %@", name)) {
            if result.count > 0 {
                return result[result.startIndex] as? Challenge
            }
        }
        return nil
    }
    public func findChallengeById(id: String) -> Challenge? {
        if let result = self.challanges?.filtered(using: NSPredicate(format: "id = %@", id)) {
            if result.count > 0 {
                return result[result.startIndex] as? Challenge
            }
        }
        return nil
    }
    
    public func findChallengeByState(state: ChallengeState) -> [Challenge] {
        var resultData = [Challenge]()
     
        if let result = self.challanges?.filtered(using: NSPredicate(format: "state == %i", state.rawValue)) {
            for c in result {
                resultData.append(c as! Challenge)
            }
        }
        return resultData
    }
    public func findChallengeByState(state: ChallengeState, state2: ChallengeState) -> [Challenge] {
        var resultData = [Challenge]()
     
        if let result = self.challanges?.filtered(using: NSPredicate(format: "state == %i OR state == %i", state.rawValue, state2.rawValue)) {
            for c in result {
                resultData.append(c as! Challenge)
            }
        }
        return resultData
    }
    public func delete() {
        let context = SharedInfo.context
        
        do {
            self.active = false
            //context.delete(self)
            if context.hasChanges {
                try context.save()
            }
        } catch {
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    public func save() {
        _ = SharedInfo.context.safeSave()
    }
}
