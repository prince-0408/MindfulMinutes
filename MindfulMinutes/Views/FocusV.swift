//
//  FocusV.swift
//  MindfulMinutes
//
//  Created by Prince Yadav on 19/11/24.
//

import AppKit
import SwiftUICore
import SwiftUI

// MARK: - View
struct FocusTrackerView: View {
    @StateObject private var viewModel = FocusTrackerViewModel()
    @State private var selectedDuration: TimeInterval = 1800 // 30 minutes
    @State private var isSessionActive = false
    
    var body: some View {
        VStack(spacing: 20) {
            headerView
            
            if isSessionActive {
                activeSessionView
            } else {
                sessionSetupView
            }
            
            statsView
        }
        .frame(width: 300)
        .padding()
        .animation(.default, value: isSessionActive)
    }
    
    private var headerView: some View {
        Text("Focus Tracker")
            .font(.largeTitle)
            .fontWeight(.bold)
    }
    
    private var sessionSetupView: some View {
        VStack(spacing: 15) {
            Picker("Duration", selection: $selectedDuration) {
                Text("15 mins").tag(900.0)
                Text("30 mins").tag(1800.0)
                Text("45 mins").tag(2700.0)
                Text("60 mins").tag(3600.0)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Button("Start Focus Session") {
                startSession()
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    private var activeSessionView: some View {
        VStack(spacing: 15) {
            Text("Focus Session Active")
                .font(.headline)
            
            Text(timeRemainingString)
                .font(.title)
            
            Text("Distractions: \(viewModel.distractionHistory.count)")
                .font(.subheadline)
            
            Button("End Session") {
                endSession()
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
        }
    }
    
    private var statsView: some View {
        VStack(spacing: 10) {
            Text("Total Focus Time: \(formatTimeInterval(viewModel.totalFocusTime))")
            Text("Total Distractions: \(viewModel.distractionHistory.count)")
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func startSession() {
        viewModel.startSession(duration: selectedDuration)
        isSessionActive = true
    }
    
    private func endSession() {
        viewModel.endSession()
        isSessionActive = false
    }
    
    private var timeRemainingString: String {
        guard let session = viewModel.currentSession else { return "00:00" }
        let remaining = max(0, session.duration - Date().timeIntervalSince(session.startTime))
        return formatTimeInterval(remaining)
    }
    
    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    FocusTrackerView()
}
