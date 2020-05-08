//
//  User+Methods.swift
//  5teps
//
//  Created by Fabio Palladino on 08/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import Foundation
import CoreData


extension User {
    
    public static var userData: User {
        get {
            let context = SharedInfo.context
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            fetchRequest.fetchBatchSize = 1
            
            do {
                
                let result = try context.fetch(fetchRequest)
                if result.count > 0 {
                    return result[0]
                }
            } catch {
                print ("Error retrieving data")
            }
            let user = User(context: SharedInfo.context)
            user.id = UUID()
            user.name = "No Name"
            return user
        }
        
    }
    public static func save() {
        _ = SharedInfo.context.safeSave()
    }
}
