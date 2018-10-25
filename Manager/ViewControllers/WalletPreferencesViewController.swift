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
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        if let passphrase = retrieveWalletPassphrase() {
            secureWalletTextField.stringValue = passphrase
            saveButton.title = "Update"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func saveButtonPressed(_ sender: NSButton) {
        savePassphraseToKeychain(passphrase: secureWalletTextField.stringValue)
    }
}
