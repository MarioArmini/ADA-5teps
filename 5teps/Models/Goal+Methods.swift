//
//  Goal+Methods.swift
//  5teps
//
//  Created by Fabio Palladino on 10/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension Goal {
    
    public static func list() -> [Goal] {
        let context = SharedInfo.context
        let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
        //fetchRequest.fetchBatchSize = 1
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            print ("Error retrieving data")
        }
        return [Goal]()
    }
    
    public static func findById(id: String) -> Goal? {
        let context = SharedInfo.context
        let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
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
    
    public static func findLastGoal() -> Goal? {
        let context = SharedInfo.context
        let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
        fetchRequest.fetchBatchSize = 1
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
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
    
    public func save() {
        _ = SharedInfo.context.safeSave()
    }
    public static func getMaxLevel() ->Int {
        var level = 0
        
        let goals = Goal.list()
        for g in goals {
            level = max(level,Int(g.level))
        }
        
        return level + 1
    }
    public static func getNameLevel(level: Int16) -> String {
        var name = "Beginner"
        if (level > 10 && level <= 20) {
            name = "Intermediate"
        } else if (level > 20 && level <= 30) {
            name = "Master"
        } else {
            name = "Gran Master"
        }
        return name
    }
}
