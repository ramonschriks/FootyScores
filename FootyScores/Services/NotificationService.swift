//
//  NotificationService.swift
//  FootyScores
//
//  Created by Ramon Schriks on 23-10-17.
//  Copyright © 2017 Ramon Schriks. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationService {
    
    
    init() {
        initNotificationSetupCheck()
    }
    
    func sendNotification(withIdentifier id: String, withTitle title: String, withBody body: String, withSubtitle subtitle: String = "") {
        let notification = UNMutableNotificationContent()
        notification.title = title
        notification.body = body
        notification.subtitle = subtitle
        
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: notification, trigger: notificationTrigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    private func initNotificationSetupCheck() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert])
        { (success, error) in
            if success {
                print("Permission Granted")
            } else {
                print("There was a problem!")
            }
        }
    }
}
