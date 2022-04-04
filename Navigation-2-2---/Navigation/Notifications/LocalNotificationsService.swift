//
//  LocalNotificationsService.swift
//  Navigation
//
//  Created by Artemiy Zuzin on 03.04.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import Foundation
import UserNotifications
import CoreLocation

final class LocalNotificationsService: NSObject {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func registeForLatestUpdatesIfPossible() {
        self.registerUpdatesCategory()
        
        self.notificationCenter.requestAuthorization(options: [.alert, .sound, .badge, .provisional]) { granted, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription).")
                
                return
            }
                        
            if granted {
                self.checkLastestUpdatesNotification()
            } else {
                print("❌ User does not want to receive notifications.")
            }
        }
    }
    
    private func checkLastestUpdatesNotification() {
        self.notificationCenter.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        
        content.title = NSLocalizedString("Check out the latest updates", comment: "")
        content.sound = .default
        content.badge = 1
        content.userInfo = ["CustomData": "qwerty"]
        content.categoryIdentifier = Categories.updates.rawValue
        
        var dateComponents = DateComponents()
        
        dateComponents.hour = 19
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        self.notificationCenter.add(request)
    }
    
    func checkYoursGeolocation() {
        self.notificationCenter.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        
        content.title = NSLocalizedString("You are near the airport", comment: "")
        content.subtitle = NSLocalizedString("Check upcoming flights", comment: "")
        content.sound = .default
        content.badge = 1
        content.userInfo = ["CustomData": "qwerty"]
        content.categoryIdentifier = Categories.geolocation.rawValue
        
        let region = CLCircularRegion(
            center: CLLocationCoordinate2D(latitude: 55.4145088, longitude: 37.8999786),
            radius: 1000,
            identifier: "Domodedovo"
        )
                
        let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        self.notificationCenter.add(request)
    }
    
    private func registerUpdatesCategory() {
        let firstShow = UNNotificationAction(
            identifier: Categories.updates.rawValue,
            title: NSLocalizedString("Show more", comment: ""),
            options: .foreground
        )
        
        let firstCategory = UNNotificationCategory(
            identifier: Categories.updates.rawValue,
            actions: [firstShow],
            intentIdentifiers: [],
            options: []
        )
        
        let secondShow = UNNotificationAction(
            identifier: Categories.geolocation.rawValue,
            title: NSLocalizedString("Show more", comment: ""),
            options: .foreground
        )
        
        let secondCategory = UNNotificationCategory(
            identifier: Categories.geolocation.rawValue,
            actions: [secondShow],
            intentIdentifiers: [],
            options: []
        )
        
        self.notificationCenter.setNotificationCategories([firstCategory, secondCategory])
    }
    
}
