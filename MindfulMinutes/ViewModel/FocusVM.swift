//
//  FocusVM.swift
//  MindfulMinutes
//
//  Created by Prince Yadav on 19/11/24.
//

import Foundation
import Combine

// MARK: - ViewModel
class FocusTrackerViewModel: ObservableObject {
    @Published private(set) var currentSession: FocusSession?
    @Published private(set) var totalFocusTime: TimeInterval = 0
    @Published private(set) var distractionHistory: [Distraction] = []
    
    private let distractionTracker: DistractionTrackerProtocol
    private let notificationService: NotificationServiceProtocol
    private var sessionTimer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    init(
        distractionTracker: DistractionTrackerProtocol = DistractionTracker(),
        notificationService: NotificationServiceProtocol = NotificationService()
    ) {
        self.distractionTracker = distractionTracker
        self.notificationService = notificationService
    }
    
    func startSession(duration: TimeInterval) {
        let session = FocusSession(
            id: UUID(),
            startTime: Date(),
            duration: duration,
            distractions: []
        )
        currentSession = session
        
        startSessionMonitoring(duration: duration)
    }
    
    private func startSessionMonitoring(duration: TimeInterval) {
        sessionTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self, let session = self.currentSession else {
                timer.invalidate()
                return
            }
            
            let elapsedTime = Date().timeIntervalSince(session.startTime)
            
            if let distraction = self.distractionTracker.detectDistraction() {
                self.handleDistraction(distraction)
            }
            
            if elapsedTime >= duration {
                self.endSession()
                timer.invalidate()
            }
        }
    }
    
    private func handleDistraction(_ distraction: Distraction) {
        distractionHistory.append(distraction)
        notificationService.sendFocusNotification(
            title: "Focus Interrupted",
            body: "Distraction detected: \(distraction.type.description)"
        )
    }
    
    func endSession() {
        guard let session = currentSession else { return }
        
        totalFocusTime += Date().timeIntervalSince(session.startTime)
        sessionTimer?.invalidate()
        
        notificationService.sendFocusNotification(
            title: "Focus Session Complete",
            body: "Session ended with \(distractionHistory.count) distractions"
        )
        
        currentSession = nil
    }
}
