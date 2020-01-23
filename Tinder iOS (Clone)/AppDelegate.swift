//  AppDelegate.swift
//  Tinder iOS (Clone)
//  Created by Jerry Tan on 23/01/2020.
//  Copyright © 2020 Jerry Tan. All rights reserved.


import UIKit
import Parse
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //MARK: PARSE CONFIGURATION
        let configuration = ParseClientConfiguration {
            $0.applicationId = "PASTE_YOUR_APPLICATION_ID_HERE"
            $0.clientKey = "PASTE_YOUR_CLIENT_ID_HERE"
            $0.server = "https://parseapi.back4app.com"
        }
        
        Parse.initialize(with: configuration)
        
        saveInstallationObject()
        
        return true
    }
    func saveInstallationObject(){
        if let installation = PFInstallation.current(){
            installation.saveInBackground {
                (success: Bool, error: Error?) in
                if (success) {
                    print("You have successfully connected your app to Back4App!")
                } else {
                    if let myError = error{
                        print(myError.localizedDescription)
                    }else{
                        print("Uknown error")
                    }
                }
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
    
    }

}

