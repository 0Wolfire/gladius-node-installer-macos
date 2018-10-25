//
//  AdvancedPreferenceViewController.swift
//  Gladius
//
//  Created by Nathan Grey on 10/25/18.
//  Copyright © 2018 Nathan Feldsien. All rights reserved.
//

import Cocoa

class AdvancedPreferenceViewController: NSViewController {
    
    @IBOutlet weak var addToPathButton: NSButton!
    @IBOutlet weak var openTerminalButton: NSButton!
    
    override func viewWillAppear() {
        addToPathButton.isEnabled = !isInPath()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func addToPathButtonPressed(_ sender: NSButton) {
        if (!isInPath()) {
            addToPath()
        }
        addToPathButton.isEnabled = !isInPath()
    }
    
    @IBAction func openTerminalButtonPressed(_ sender: NSButton) {
        launchTerminalApp()
    }
}
