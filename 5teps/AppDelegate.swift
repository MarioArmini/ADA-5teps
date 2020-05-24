//
//  AppDelegate.swift
//  5teps
//
//  Created by Mario Armini on 07/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import UIKit
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    public static var app: AppDelegate {
        get {
            return (UIApplication.shared.delegate as! AppDelegate)
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        
        let notificationCenter = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: options) { (didAllow, error) in
            if didAllow {
                print("User has accepted notifications")
            } else {
                print("User has declined notifications \(String(describing: error))")
            }
        }
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                print("User has declined notifications")
            } else {
                print("User has accepted notifications")
            }
        }
        notificationCenter.delegate = self
        generateScedulateNotify()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func applicationWillTerminate(_ application: UIApplication) {
        generateScedulateNotify()
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        generateScedulateNotify()
    }
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentCloudKitContainer(name: "5teps")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    // MARK: - Gestione Notifiche
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    func generateScedulateNotify() {
        var title: String = ""
        var body: String = ""
        var identifier: String = "generic"
        var timeInterval: TimeInterval = TimeInterval(SharedInfo.TIME_TO_STANDARD_NOTIFY * 60 * 60) //Notifica di default
        let inProgress = Challenge.listInProgress()
        if inProgress.count > 0 {
            var minDeadLine = Int.max
            var currentStep = 0
            var challengeName = ""
            for c in inProgress {
                if let step = c.getCurrentStepChallenge() {
                    let deadLine = step.daysToDeadline()
                    if (minDeadLine > deadLine) {
                        minDeadLine = deadLine
                        challengeName = c.name ?? ""
                        currentStep = Int(step.step)
                    }
                }
            }
            let subview = Subview()
            let message = subview.backgroundChallengeInProgress(name: challengeName, dayToLeft: minDeadLine, step: currentStep)
            title = message.title
            body = message.message
            timeInterval = TimeInterval(SharedInfo.TIME_TO_DEAD_LINE * 60 * 60) //Notifica di deadline
            identifier = "inprogress"
        } else {
            let subview = Subview()
            let message = subview.backgroundNoChallenge()
            title = message.title
            body = message.message
            identifier = "generic"
        }
        timeInterval = TimeInterval(10 * 60) //TEST
        identifier = identifier + "-\(UUID())"
        scheduleNotification(title: title, body: body, identifier: identifier, timeInterval: timeInterval)
    }
    func scheduleNotification(title: String, body: String, identifier: String, timeInterval: TimeInterval) {
        
        let notificationCenter = UNUserNotificationCenter.current()
        //notificationCenter.removeAllPendingNotificationRequests()
        //notificationCenter.removeAllDeliveredNotifications()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        //let date = Date(timeIntervalSinceNow: 60)
        let today = Date()
        let modifiedDate = Calendar.current.date(byAdding: .hour, value: 1, to: today)!
        print(modifiedDate)
        //let buf = Utils.dateToString(date: modifiedDate, format: "yyyy-mm-dd") + " 10:00"
        let buf = Utils.dateToString(date: modifiedDate, format: "yyyy-mm-dd HH:mm")
        if let dateEvent = Utils.stringToDate(string: buf, format: "yyy-mm-dd HH:mm") {
            print(dateEvent)
            let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: dateEvent)
            
            //let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: true)
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            
            notificationCenter.add(request) { (error) in
                print(request)
                if let error = error {
                    print("Error \(error.localizedDescription)")
                } else {
                    print("Request notify added \(trigger) \(identifier) \(content)")
                }
            }
        }
        
        
        /*
         let userActions = "User Actions"
         
         let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
         let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
         let category = UNNotificationCategory(identifier: userActions, actions: [snoozeAction, deleteAction], intentIdentifiers: [], options: [])
         
         notificationCenter.setNotificationCategories([category])
         */
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "generic" {
            
        } else if response.notification.request.identifier == "inprogress" {
            
        }
        
        completionHandler()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
