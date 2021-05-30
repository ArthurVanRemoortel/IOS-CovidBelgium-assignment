//
//  AppDelegate.swift
//  EhB-IOS-Werkstuk2
//
//  Created by Arthur Van Remoortel on 26/05/2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var isFirstLauch = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //self.resetFirstLaunch() // TODO: Development only. Resets the database.
        isFirstLauch = self.startupCheck()
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EhB_IOS_Werkstuk2")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func startupCheck() -> Bool{
        // http://ios-tutorial.com/detect-application-run-first-time-ios/
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore {
            print("Not first launch.")
            return false
        }
        else {
            print("First launch")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            return true
        }
    }
    
    func resetFirstLaunch() {
        // TODO: Development only. Resets database and other data.
        UserDefaults.standard.set(false, forKey: "launchedBefore")
        UserDefaults.standard.set(nil, forKey: "lastUpdateDate")
        CovidDataManager.shared.deleteDatabaseContents(context: persistentContainer.viewContext)
    }

}

