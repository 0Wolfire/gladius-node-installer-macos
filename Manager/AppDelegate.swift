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
    var guardianProcess: Process?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        config()
        
        content()
        
        let guardian = shell(command: Bundle.main.resourcePath! + "/gladius-guardian", output: false)
        guardianProcess = guardian.process
        
        launchAgent()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        quitAll()
    }
    
    func quitAll() {
        guardianProcess?.terminate()
    }
}

