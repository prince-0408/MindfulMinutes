//
//  MindfulMinutesApp.swift
//  MindfulMinutes
//
//  Created by Prince Yadav on 19/11/24.
//

import SwiftUI
import AppKit

// Notch-specific Utility App
@main
struct MindfulMinutesApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusBarItem: NSStatusItem!
    private var popover: NSPopover!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupNotchUtility()
    }
    
    private func setupNotchUtility() {
        // Create popover
        popover = NSPopover()
        popover.contentViewController = NSHostingController(rootView: FocusTrackerView())
        popover.behavior = .transient
        
        // Create status bar item
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusBarItem.button {
            button.image = NSImage(systemSymbolName: "timer", accessibilityDescription: "Focus Tracker")
            button.action = #selector(togglePopover)
        }
    }
    
    @objc private func togglePopover() {
        guard let button = statusBarItem.button else { return }
        
        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }
}


@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

// Extension for system-wide keyboard shortcut registration
extension NSEvent {
    static func addGlobalMonitorForEvents(matching mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> Void) {
        NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
    }
}
