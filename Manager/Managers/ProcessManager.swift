//
//  ProcessManager.swift
//  Gladius
//
//  Created by Nathan Grey on 10/24/18.
//  Copyright © 2018 Nathan Feldsien. All rights reserved.
//

import Foundation

class ProcessManager {
    var guardian: Process?
    var electron: Process?
    
    static let shared = ProcessManager()
    
    func kill(process: Process?) {
        process?.terminate()
    }
    
    func killAll() {
        kill(process: guardian)
        kill(process: electron)
    }
    
    func launchGuardian() {
        if guardian != nil {
            kill(process: guardian)
        }
        
        let guardianShell = shell(command: Bundle.main.resourcePath! + "/gladius-guardian", output: false)
        guardian = guardianShell.process
    }
    
    func launchElectron() {
        if electron != nil {
            kill(process: electron)
        }
        
        electron = Process()
        electron?.launchPath = Bundle.main.resourcePath! + "/Gladius.app/Contents/MacOS/Gladius"
        electron?.launch()
    }
}
