//
//  AppDelegate.swift
//  5teps
//
//  Created by Mario Armini on 07/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import UIKit
import CoreData
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    public static var app: AppDelegate {
        get {
            return (UIApplication.shared.delegate as! AppDelegate)
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.applicationIconBadgeNumber = 0
        application.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        
        
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
        registerBackgroundTask()
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
    func applicationDidEnterBackground(_ application: UIApplication) {
        scheduleAppRefresh()
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // fetch data from internet now
        guard let data = fetchSomeData() else {
            // data download failed
            completionHandler(.failed)
            return
        }
        
        if data.count > 0 {
            // data download succeeded and is new
            completionHandler(.newData)
        } else {
            // data downloaded succeeded and is not new
            completionHandler(.noData)
        }
    }
    func fetchSomeData() -> String? {
        var title: String = ""
        var body: String = ""
        var identifier: String = "generic"
        
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
            identifier = "inprogress"
        } else {
            let subview = Subview()
            let message = subview.backgroundNoChallenge()
            title = message.title
            body = message.message
            identifier = "generic"
        }
        
        scheduleNotification(title: title, body: body, identifier: identifier)
        return "dati"
    }
    func scheduleNotification(title: String, body: String, identifier: String) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        //let date = Date(timeIntervalSinceNow: 60)
        //let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        //let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
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
    //MARK: Register BackGround Tasks
    private func registerBackgroundTask() {
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.5steps.bgservice", using: nil) { task in
            DispatchQueue.global().async {
                let _ = self.fetchSomeData()
                task.setTaskCompleted(success: true)
            }
            self.scheduleAppRefresh()
        }
        scheduleAppRefresh()
    }
    
    func scheduleAppRefresh() {
        let request = BGProcessingTaskRequest(identifier: "com.5steps.bgservice")
        request.requiresNetworkConnectivity = false // Need to true if your task need to network process. Defaults to false.
        request.requiresExternalPower = false  //If we keep requiredExternalPow*er = true then it required device is connected to external power.
        
        request.earliestBeginDate = Date(timeIntervalSinceNow: 1 * 60) // fetch Image Count after 1 minute.
        
        do {
            BGTaskScheduler.shared.cancelAllTaskRequests()
            try BGTaskScheduler.shared.submit(request)
            print("scheduleAppRefresh register")
        } catch {
            print("Could not scheduleAppRefresh fetch: (error)")
        }
    }
    func cancelAllPendingBGTask() {
        BGTaskScheduler.shared.cancelAllTaskRequests()
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
