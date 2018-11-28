//
//  RequestManager.swift
//  Gladius
//
//  Created by Nathan Grey on 10/24/18.
//  Copyright © 2018 Nathan Feldsien. All rights reserved.
//

import Foundation

class RequestManager {
    let sessionConfig = URLSessionConfiguration.default
//    let operationQueue = OperationQueue.init()
    var retry = true
    
    func sendGuardianTimeoutRequest() {
        /* Create session, and optionally set a URLSessionDelegate. */
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: OperationQueue.main)
        
        guard let URL = URL(string: "http://localhost:7791/service/set_timeout") else {return}
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"
        
        // Headers
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // JSON Body
        
        let bodyObject: [String : Any] = [
            "timeout": 5
        ]
        request.httpBody = try! JSONSerialization.data(withJSONObject: bodyObject, options: [])
        
        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                self.sendGuardianStartRequest()
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
                if (error != nil) {
                    self.sendGuardianTimeoutRequest()
                }
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    func sendGuardianStartRequest() {
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: OperationQueue.main)

        guard let URL = URL(string: "http://localhost:7791/service/set_state/all") else {return}
        var request = URLRequest(url: URL)
        request.httpMethod = "PUT"
        
        // Headers
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // JSON Body
        
        let bodyObject: [String : Any] = [
            "running": true
        ]
        request.httpBody = try! JSONSerialization.data(withJSONObject: bodyObject, options: [])
        
        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                if (UserDefaults.standard.bool(forKey: "UseKeychain")) {
                    self.sendOpenWalletRequest()
                }
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    func sendOpenWalletRequest() {
        if let passphrase = retrieveWalletPassphrase() {
            /* Create session, and optionally set a URLSessionDelegate. */
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: OperationQueue.main)
            
            /* Create the Request:
             Open (POST http://localhost:3001/api/keystore/account/open)
             */
            
            guard let URL = URL(string: "http://localhost:3001/api/keystore/account/open") else {return}
            var request = URLRequest(url: URL)
            request.httpMethod = "POST"
            
            // Headers
            
            request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            // JSON Body
            
            let bodyObject: [String : Any] = [
                "passphrase": passphrase
            ]
            request.httpBody = try! JSONSerialization.data(withJSONObject: bodyObject, options: [])
            
            /* Start a new Task */
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                if (error == nil) {
                    // Success
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("URL Session Task Succeeded: HTTP \(statusCode)")
                }
                else {
                    // Failure
                    print("URL Session Task Failed: %@", error!.localizedDescription);
                }
            })
            task.resume()
            session.finishTasksAndInvalidate()
        } else {
            return
        }
    }
}
