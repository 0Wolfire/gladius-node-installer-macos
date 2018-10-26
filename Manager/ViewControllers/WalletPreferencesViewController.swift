//
//  WalletPreferencesViewController.swift
//  Gladius
//
//  Created by Nathan Grey on 10/25/18.
//  Copyright © 2018 Nathan Feldsien. All rights reserved.
//

import Cocoa

class WalletPreferencesViewController: NSViewController {
    @IBOutlet weak var secureWalletTextField: NSSecureTextField!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var saveInKeychainCheckbox: NSButton!
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        if let passphrase = retrieveWalletPassphrase() {
            secureWalletTextField.stringValue = passphrase
            saveButton.title = "Update"
        }
        
        if (UserDefaults.standard.bool(forKey: "UseKeychain")) {
            saveButton.isEnabled = true
            secureWalletTextField.isEnabled = true
            saveInKeychainCheckbox.state = .on
        } else {
            saveButton.isEnabled = false
            secureWalletTextField.isEnabled = false
            saveInKeychainCheckbox.state = .off
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func saveButtonPressed(_ sender: NSButton) {
        savePassphraseToKeychain(passphrase: secureWalletTextField.stringValue)
        saveButton.title = "Update"
    }
    @IBAction func saveInKeychainCheckboxPressed(_ sender: NSButton) {
        UserDefaults.standard.set((sender.state == .on), forKey: "UseKeychain")
        if (sender.state == .off) {
            deleteWalletPassphrase()
            secureWalletTextField.stringValue = ""
            saveButton.title = "Save"
            saveButton.isEnabled = false
            secureWalletTextField.isEnabled = false
        } else {
            saveButton.isEnabled = true
            secureWalletTextField.isEnabled = true
        }
    }
}
