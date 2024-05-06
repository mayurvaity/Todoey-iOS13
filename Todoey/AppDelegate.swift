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
        
        //to get location of realm db
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do {
            //to create a realm object here, it acts as CONTEXT
            // making it underscore as we r not using it 
            _ = try Realm()
    
        } catch {
            print("Error initialising new realm, \(error)")
        }
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("applicationWillTerminate")
    }
    
}

