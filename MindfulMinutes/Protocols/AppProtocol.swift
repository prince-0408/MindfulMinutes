//
//  AppProtocol.swift
//  MindfulMinutes
//
//  Created by Prince Yadav on 19/11/24.
//

// MARK: - Protocols
protocol DistractionTrackerProtocol {
    func detectDistraction() -> Distraction?
}

protocol NotificationServiceProtocol {
    func sendFocusNotification(title: String, body: String)
}
