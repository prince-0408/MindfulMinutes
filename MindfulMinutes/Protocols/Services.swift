//
//  Services.swift
//  MindfulMinutes
//
//  Created by Prince Yadav on 19/11/24.
//

import UserNotifications

// MARK: - Services
class DistractionTracker: DistractionTrackerProtocol {
    func detectDistraction() -> Distraction? {
        // Simulated distraction detection
        guard Bool.random() else { return nil }
        
        let types: [DistractionType] = [.notification, .screenSwitch, .audioPlayback]
        return Distraction(
            id: UUID(),
            timestamp: Date(),
            type: types.randomElement()!
        )
    }
}

class NotificationService: NotificationServiceProtocol {
    private let center = UNUserNotificationCenter.current()
    
    func sendFocusNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        )
        
        center.add(request)
    }
}
