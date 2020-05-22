//
//  SharedInfo.swift
//  Test2
//
//  Created by Fabio Palladino on 02/05/2020.
//  Copyright © 2020 Fabio Palladino. All rights reserved.
//

import Foundation
import CoreData

public class SharedInfo {
    static let TIME_TO_STANDARD_NOTIFY = 6
    static let TIME_TO_DEAD_LINE = 1
    
    static var app: AppDelegate {
        return AppDelegate.app
    }
    public static var context: NSManagedObjectContext {
        return AppDelegate.app.persistentContainer.viewContext
    }
}

extension NSManagedObjectContext {
    public func safeSave() -> Bool {
        do {

            if self.hasChanges {
                try self.save()
            }
            return true
        } catch {
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return false
    }
}
