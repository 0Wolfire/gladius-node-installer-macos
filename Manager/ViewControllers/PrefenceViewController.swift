//
//  PrefenceViewController.swift
//  Gladius
//
//  Created by Nathan Grey on 10/23/18.
//  Copyright © 2018 Nathan Feldsien. All rights reserved.
//

import Cocoa

class PrefenceViewController: NSViewController {

    @IBOutlet weak var runAtLoginButton: NSButton!
    @IBOutlet weak var openInterfaceAtLoginButton: NSButton!
    @IBOutlet weak var autoLaunchInterface: NSButton!
    
    override func viewWillAppear() {
        if UserDefaults.standard.object(forKey: "StartupRunAtLogin") == nil || UserDefaults.standard.bool(forKey: "StartupRunAtLogin") {
            runAtLoginButton.state = .on
            openInterfaceAtLoginButton.isEnabled = true
        } else {
            runAtLoginButton.state = .off
            openInterfaceAtLoginButton.isEnabled = false
        }
        
        if UserDefaults.standard.object(forKey: "StartupAutoLaunchUIAtLogin") == nil || UserDefaults.standard.bool(forKey: "StartupAutoLaunchUIAtLogin") {
            openInterfaceAtLoginButton.state = .on
        } else {
            openInterfaceAtLoginButton.state = .off
        }
        
        if UserDefaults.standard.object(forKey: "AutoLaunchUI") == nil || UserDefaults.standard.bool(forKey: "AutoLaunchUI") {
            autoLaunchInterface.state = .on
        } else {
            autoLaunchInterface.state = .off
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func runAtLoginButtonPressed(_ sender: NSButton) {
        UserDefaults.standard.set((sender.state == .on), forKey: "StartupRunAtLogin")
        openInterfaceAtLoginButton.isEnabled = (sender.state == .on)
        launchAgent()
    }
    
    @IBAction func openInterfaceAtLoginButtonPressed(button sender: NSButton) {
        UserDefaults.standard.set((sender.state == .on), forKey: "StartupAutoLaunchUIAtLogin")
    }
    
    @IBAction func autoLaunchInterfaceButtonPressed(_ sender: NSButton) {
        UserDefaults.standard.set((sender.state == .on), forKey: "AutoLaunchUI")
    }
}
