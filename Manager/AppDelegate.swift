//
//  AppDelegate.swift
//  Test
//
//  Created by Nathan Grey on 5/18/18.
//  Copyright © 2018 Nathan Grey. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        config()
        launchAgent()
        startGuardian()
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if (UserDefaults.standard.object(forKey: "AutoLaunchUI") == nil || UserDefaults.standard.bool(forKey: "AutoLaunchUI")) {
            ProcessManager.shared.launchElectron()
        }
        
        return true
    }
    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        ProcessManager.shared.killAll()
        
        return NSApplication.TerminateReply.terminateNow
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        ProcessManager.shared.killAll()
    }
}

