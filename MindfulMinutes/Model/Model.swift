//
//  Model.swift
//  MindfulMinutes
//
//  Created by Prince Yadav on 19/11/24.
//

import SwiftUI
import Combine
import UserNotifications

// MARK: - Domain Entities
struct FocusSession: Identifiable {
    let id: UUID
    let startTime: Date
    let duration: TimeInterval
    let distractions: [Distraction]
}

struct Distraction: Identifiable {
    let id: UUID
    let timestamp: Date
    let type: DistractionType
}

enum DistractionType {
    case notification
    case screenSwitch
    case audioPlayback
    
    var description: String {
        switch self {
        case .notification: return "Notification"
        case .screenSwitch: return "Screen Switch"
        case .audioPlayback: return "Audio Playback"
        }
    }
}
