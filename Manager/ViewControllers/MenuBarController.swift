//
//  MenuBarController.swift
//  Manager
//
//  Created by Nathan Grey on 5/31/18.
//  Copyright © 2018 Nathan Grey. All rights reserved.
//

import Cocoa

class MenuBarController: NSObject {
    @IBOutlet weak var mainMenu: NSMenu!
    @IBOutlet weak var showManagerItem: NSMenuItem!
    @IBOutlet weak var quitItem: NSMenuItem!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    var localPath: Bool {
        get {
            return isInPath()
        }
    }
    
    override func awakeFromNib() {
        let icon = NSImage(named: "MenuBar")
        icon?.size = NSSize(width: 16, height: 14)
        statusItem.image = icon
        statusItem.menu = mainMenu
    }
    
    @IBAction func showManagerItemClicked(_ sender: NSMenuItem) {
        ProcessManager.shared.launchElectron()
    }
    
    @IBAction func closeDashboardMenuClicked(_ sender: Any) {
        ProcessManager.shared.kill(process: ProcessManager.shared.electron)
    }
    
    @IBAction func openTerminalClicked(_ sender: Any) {
        launchTerminalApp()
    }
    
    @IBAction func quitItemClicked(_ sender: NSMenuItem) {
        ProcessManager.shared.killAll()
        NSApplication.shared.terminate(self)
    }
}
