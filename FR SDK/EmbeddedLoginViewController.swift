//
//  EmbeddedLoginViewController.swift
//  FR SDK
//
//  Created by vahan.harutyunyan  on 1/4/22.
//

import Foundation
import UIKit
import FRAuth

class EmbeddedLoginViewController: UIViewController, StatusUpdatable, ViewControllerPushing {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Forge Rock"
        
        //setup and initialize FR SDK
        FRLog.setLogLevel([.network, .all])
        FRAuth.configPlistFileName = "FRAuthConfig"
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
            FRUser.login() { user, node, error in
                if error != nil {
                    print(error.debugDescription)
                    self.updateStatus("Authentication Error", type: .error)
                } else if user != nil {
                    self.updateStatus("Login Success:", type: .success)
                    self.pushUserInfoVC()
                } else if let node = node {
                    self.pushNodeVC(node)
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
