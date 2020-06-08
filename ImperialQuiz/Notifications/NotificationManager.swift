//
//  NotificationManager.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 21/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationManager: NSObject {
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    static let shared = NotificationManager()
    
    private override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    func requestAutorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] (granted, _) in
            guard granted else { return }
            self?.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        notificationCenter.getNotificationSettings { _ in
        }
    }
    
    func scheduleLocalNotification(_ title: String, delay: TimeInterval) {
        let userAction = "User Action"
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = "Test local notification - \(title)"
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = userAction
        content.attachments = {
            guard let path = Bundle.main.path(forResource: "attachment", ofType: "png"),
                  let attachment = try? UNNotificationAttachment(identifier: "Image", url: URL(fileURLWithPath: path), options: nil) else { return [UNNotificationAttachment]() }
            return [attachment]
        }()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        
        let identifier = "Local Notification"
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            guard let error = error else { return }
            print(error.localizedDescription)
        }
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
        
        let category = UNNotificationCategory(identifier: userAction, actions: [snoozeAction, deleteAction], intentIdentifiers: [], options: [])
        notificationCenter.setNotificationCategories([category])
        
    }
    
    func scheduleTopRatingLocalNotification(title: String, rating: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = "Congratulations!\nYou have new top rating: " + String(repeating: "★", count: rating)
        content.sound = UNNotificationSound.default
        content.attachments = {
            guard let path = Bundle.main.path(forResource: "attachment", ofType: "png"),
                  let attachment = try? UNNotificationAttachment(identifier: "Image", url: URL(fileURLWithPath: path), options: nil) else { return [UNNotificationAttachment]() }
            return [attachment]
        }()
        
        let identifier = "Local Notification"
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
        notificationCenter.add(request, withCompletionHandler: nil)
    }
    
    func scheduleNewSectionLocalNotification(title: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = "New section has been downloaded: " + title
        content.sound = UNNotificationSound.default
        content.attachments = {
            guard let path = Bundle.main.path(forResource: "attachment", ofType: "png"),
                  let attachment = try? UNNotificationAttachment(identifier: "Image", url: URL(fileURLWithPath: path), options: nil) else { return [UNNotificationAttachment]() }
            return [attachment]
        }()
        
        let identifier = "Local Notification"
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
        notificationCenter.add(request, withCompletionHandler: nil)
    }
    
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard response.notification.request.identifier == "Local Notification" else { return }
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier: completionHandler()
        case UNNotificationDismissActionIdentifier: completionHandler()
        case "Snooze": scheduleLocalNotification("Reminder", delay: 5)
        case "Delete": completionHandler()
        default: fatalError("Unknow notification action")
        }
    }
     
}
