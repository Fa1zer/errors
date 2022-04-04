//
//  AppDelegate.swift
//  Navigation
//
//  Created by Artem Novichkov on 12.09.2020.
//  Copyright © 2020 Artem Novichkov. All rights reserved.
//

import UIKit
import Firebase
import CoreData

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let localNotificationsService = LocalNotificationsService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let appConfiguration = AppConfiguration.allCases.randomElement()
        
        NetworkService.dataTaskFromURL(URL: URL(string: appConfiguration!.rawValue)!)
        
        FirebaseApp.configure()
                
        localNotificationsService.notificationCenter.delegate = self
        localNotificationsService.registeForLatestUpdatesIfPossible()
        
        return true
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            print("default action identifier")
        case Categories.updates.rawValue:
            self.localNotificationsService.checkYoursGeolocation()
        case Categories.geolocation.rawValue:
            print(Categories.geolocation.rawValue)
        default:
            break
        }
        
        completionHandler()
    }
    
}

