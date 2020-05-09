//
//  Topic+Methods.swift
//  Test2
//
//  Created by Fabio Palladino on 02/05/2020.
//  Copyright © 2020 Fabio Palladino. All rights reserved.
//

import Foundation
import CoreData


extension Topic {
    
    public static func list() -> [Topic] {
        let context = SharedInfo.context
        let fetchRequest: NSFetchRequest<Topic> = Topic.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
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
    public func delete() {
        let context = SharedInfo.context
        
        do {
            context.delete(self)
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
