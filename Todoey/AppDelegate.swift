//
//  AppDelegate.swift
//  Destini
//
//  Created by Philipp Muellauer on 01/09/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //        print("didFinishLaunchingWithOptions")
        
        //to get path of the plist file where "user defaults" will be stored
        //        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
        //to get location of realm db
        print(Realm.Configuration.defaultConfiguration.fileURL)  
        
        //creating an object of data class (custom class)
        let data = Data()
        data.name = "Mayur"
        data.age = 12
        
        do {
            //to create a realm object here, it acts as CONTEXT
            let realm = try Realm()
            
            //preparing to write to realm db
            try realm.write {
                //adding an entry to realm db
                realm.add(data)
            }
        } catch {
            print("Error initialising new realm, \(error)")
        }
        
        
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("applicationWillTerminate")
    }
    
    //MARK: - Added from CoreDataTest
    
    // MARK: - Core Data stack
    //NSPersistentContainer means SQLlite database
    lazy var persistentContainer: NSPersistentContainer = {
        //below name should match with our data model file, hence changed to DataModel 
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        //context is like a staging area before data is stored in the database mentioned above 
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
    
    
    
}

