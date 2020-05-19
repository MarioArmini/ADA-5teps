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

public struct CurrentLevel {
    var level: Int
    var count: Int
    
    init(level: Int, count: Int) {
        self.level = level
        self.count = count
    }
}
extension Goal {
    public static let MAX_GOAL_CHANGE_LEVEL = 5
    
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
    public static func getMaxLevel() -> CurrentLevel {
        var level = 1
        var levelCount = [Int:Int]()
        levelCount[level] = 0
        
        let goals = Goal.list()
        for g in goals {
            level = max(level,Int(g.level))
            if !levelCount.keys.contains(level) {
                levelCount[level] = 0
            }
            levelCount[level] = levelCount[level]! + 1
        }
        
        let curLevel = CurrentLevel(level: level, count: levelCount[level]!)
        return curLevel
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
    public static func generaFakeGoals() -> [Goal] {
        var result = [Goal]()
        
        let challenges = Challenge.list()
        
        for _ in 1...20 {
            let c = challenges[Int.random(in: 0..<challenges.count)]
            
            var currentLevel = Goal.getMaxLevel()
            if (currentLevel.count + 1) >= MAX_GOAL_CHANGE_LEVEL {
                currentLevel.level = currentLevel.level + 1
                currentLevel.count = 0
            }
            print("Level \(currentLevel.level) - \(currentLevel.count)")
            
            let goal = Goal(context: SharedInfo.context)
            goal.id = UUID()
            goal.date = Date()
            goal.level = Int16(currentLevel.level)
            goal.name = c.name
            goal.icon = Goal.findIconMedal(level: goal.level)
            goal.challenge = c
            goal.save()
            result.append(goal)
        }
        return result
    }
    public static func getPercentualeComplete(level: CurrentLevel) -> CGFloat{
        var val: Int = 0
        
        val = level.count * 360/MAX_GOAL_CHANGE_LEVEL
        
        return Ring.degreeToRadiant(gradi: val)
    }
    public static func findIconMedal(level: Int16)  -> String {
        let icons = Utils.getArrayIconMedal()
        
        let i = Int.random(in: 0..<icons.count)
        return icons[i]
    }
}
