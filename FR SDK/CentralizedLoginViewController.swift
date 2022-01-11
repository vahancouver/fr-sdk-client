//
//  CentralizedLoginViewController.swift
//  FR SDK
//
//  Created by vahan.harutyunyan  on 1/10/22.
//

import UIKit
import FRAuth

class CentralizedLoginViewController: UIViewController, StatusUpdatable, ViewControllerPushing {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Forge Rock"
        
        //setup and initialize FR SDK
        FRAuth.configPlistFileName = "FRAuthConfigCentralized"
        FRLog.setLogLevel([.network, .all])
        do {
            try FRAuth.start()
            print("SDK initialized successfully")
            updateStatus("SDK ready", type: .success)
        }
        catch {
            print(error)
        }
        
        //check for existing user
        if FRUser.currentUser != nil {
            updateUI(loggedIn: true)
            updateStatus("Logged in user detected", type: .info)
        } else {
            updateUI(loggedIn: false)
            updateStatus("Please log in", type: .info)
        }
        
        
    }
    
    @IBAction func actionButtontapped(_ sender: UIButton) {
        if FRUser.currentUser == nil {
            //  BrowserBuilder
            if let browserBuilder = FRUser.browser() {
                browserBuilder.set(presentingViewController: self)
                browserBuilder.setCustomParam(key: "acr_values", value: "UsernamePasswordCheck")
                
                //  Browser
                let browser = browserBuilder.build()
                
                // Login
                browser.login{ (user, error) in
                    if let error = error {
                        // Handle error
                        self.updateStatus(error.localizedDescription, type: .error)
                    }
                    else if let user = user {
                        // Handle authenticated status
                        print(user.debugDescription)
                        self.pushUserInfoVC()
                    }
                }
            }
        } else {
            FRUser.currentUser?.logout()
            updateUI(loggedIn: false)
            updateStatus("Logged out", type: .success)
        }
    }
    
    private func updateUI(loggedIn: Bool) {
        DispatchQueue.main.async {
            self.actionButton.setTitle(loggedIn ? "Logout" : "Login", for: .normal)
        }
    }
    
}

