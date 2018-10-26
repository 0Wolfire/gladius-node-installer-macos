//
//  Utilities.swift
//  Gladius
//
//  Created by Nathan Grey on 6/6/18.
//  Copyright © 2018 Nathan Grey. All rights reserved.
//

import Cocoa
import Foundation
import ServiceManagement

let homeFolderURL = FileManager.default.homeDirectoryForCurrentUser

public func shell(command: String, output: Bool) -> (process: Process, output: String?) {
    let process = Process()
    
    process.launchPath = "/bin/bash"
    process.arguments = ["-c", command]
    
    if output {
        let pipe = Pipe()
        process.standardOutput = pipe
        process.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: String.Encoding.utf8)
        
        return (process, output)
    } else {
        process.launch()
        return (process, nil)
    }
}

public func config() {
    try? FileManager.default.createDirectory(at: homeFolderURL.appendingPathComponent(".config/gladius/wallet"), withIntermediateDirectories: true, attributes: nil)
    try? FileManager.default.createDirectory(at: homeFolderURL.appendingPathComponent(".config/gladius/keys"), withIntermediateDirectories: true, attributes: nil)
    try? FileManager.default.copyItem(at: URL(fileURLWithPath: Bundle.main.resourcePath! + "/gladius-guardian.toml"), to: homeFolderURL.appendingPathComponent(".config/gladius/gladius-guardian.toml"))
}

public func content() {
    try? FileManager.default.copyItem(at: URL(fileURLWithPath: Bundle.main.resourcePath! + "/content"), to: homeFolderURL.appendingPathComponent(".config/gladius/content"))
}

func update() {
    try? FileManager.default.removeItem(at: URL(string: "file:///usr/local/bin/gladius")!)
}

public func launchAgent() {
    if (UserDefaults.standard.bool(forKey: "StartupRunAtLogin")) {
        try? FileManager.default.createDirectory(at: homeFolderURL.appendingPathComponent("Library/LaunchAgents"), withIntermediateDirectories: false, attributes: nil)
        
        do {
            try FileManager.default.createSymbolicLink(at: homeFolderURL.appendingPathComponent("Library/LaunchAgents/com.gladius.io.node-manager.plist"), withDestinationURL: URL(fileURLWithPath: Bundle.main.resourcePath! + "/com.gladius.io.node-manager.plist"))
        } catch {
            print(error)
        }
    } else {
        try? FileManager.default.removeItem(at: homeFolderURL.appendingPathComponent("Library/LaunchAgents/com.gladius.io.node-manager.plist"))
    }
}

func launchTerminalApp() {
    NSWorkspace.shared.launchApplication("Terminal", showIcon: false, autolaunch: false)
}

public func isInPath() -> Bool {
    let symlinkExists = FileManager.default.fileExists(atPath: "/usr/local/bin/gladius")
    let zshrcExists = FileManager.default.fileExists(atPath: homeFolderURL.appendingPathComponent(".zshrc").absoluteString.replacingOccurrences(of: "file://", with: ""))
    
    let rcFile: String
    if zshrcExists {
        rcFile = ".zshrc"
    } else {
        rcFile = ".bash_profile"
    }
    
    let profileExport: Bool
    let shellScript = shell(command: "cat ~/\(rcFile)", output: true)
    
    if let shellPreferences = shellScript.output {
        profileExport = shellPreferences.contains("gladius/paths")
    } else {
        profileExport = false
    }
    
    return (symlinkExists || profileExport)
}

public func addToPath() {
    do {
        let symlinkExists = FileManager.default.fileExists(atPath: "/usr/local/bin/gladius")
        if !symlinkExists {
            try FileManager.default.createSymbolicLink(at: URL(string: "file:///usr/local/bin/gladius")!, withDestinationURL: URL(fileURLWithPath: Bundle.main.resourcePath! + "/gladius"))
        }
    } catch {
        let zshrcExists = FileManager.default.fileExists(atPath: homeFolderURL.appendingPathComponent(".zshrc").absoluteString.replacingOccurrences(of: "file://", with: ""))
        
        let rcFile: String
        if zshrcExists {
            rcFile = ".zshrc"
        } else {
            rcFile = ".bash_profile"
        }
        
        guard let shellPreferences = shell(command: "cat ~/\(rcFile)", output: true).output
            else {
                return
        }
        
        if !shellPreferences.contains("gladius/paths") {
            let _ = shell(command: "echo \"export PATH=\\$PATH:/Applications/Gladius.app/Contents/Resources\"  > ~/.config/gladius/paths", output: false)
            let _ = shell(command: "echo \"source ~/.config/gladius/paths\"  >> ~/\(rcFile)", output: false)
        }
    }
}

func savePassphraseToKeychain(passphrase: String) {
    let password = passphrase.data(using: String.Encoding.utf8)!
    let addQuery: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrLabel as String: "Gladius Wallet",
        kSecAttrGeneric as String: "gladius.io",
        kSecAttrService as String: "gladius.io",
        kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
        kSecAttrIsInvisible as String: kCFBooleanTrue,
        kSecAttrSynchronizable as String: kCFBooleanFalse,
        kSecValueData as String: password
    ]
    
    let updateQuery: [String: Any] = [
        kSecValueData as String: password
    ]
    
    if retrieveWalletPassphrase() != nil {
        let status = SecItemUpdate(addQuery as CFDictionary, updateQuery as CFDictionary)
        print(status)
    } else {
        let status = SecItemAdd(addQuery as CFDictionary, nil)
        print(status)
    }
}

func retrieveWalletPassphrase() -> String? {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrLabel as String: "Gladius Wallet",
        kSecMatchLimit as String: kSecMatchLimitOne,
        kSecReturnAttributes as String: true,
        kSecReturnData as String: true
    ]
    
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    //        guard status != errSecItemNotFound else { return  }
    //        guard status == errSecSuccess else { return }
    
    print(status)
    
    guard let existingItem = item as? [String : Any],
        let passwordData = existingItem[kSecValueData as String] as? Data,
        let searchpassword = String(data: passwordData, encoding: String.Encoding.utf8)
        else {
            return nil
            
    }
    
    return searchpassword
}

func deleteWalletPassphrase() {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrLabel as String: "Gladius Wallet",
        kSecMatchLimit as String: kSecMatchLimitOne,
        kSecReturnAttributes as String: true,
        kSecReturnData as String: true
    ]
    
    SecItemDelete(query as CFDictionary)
}

public func startGuardian() {
    ProcessManager.shared.launchGuardian()
    
    if ((UserDefaults.standard.object(forKey: "StartupRunAtLogin") == nil ||  UserDefaults.standard.bool(forKey: "StartupRunAtLogin")) &&
        (UserDefaults.standard.object(forKey: "StartupAutoLaunchUIAtLogin") == nil ||  UserDefaults.standard.bool(forKey: "StartupAutoLaunchUIAtLogin")))
    {
        ProcessManager.shared.launchElectron()
    }
    
    RequestManager.init().sendGuardianTimeoutRequest()
}
