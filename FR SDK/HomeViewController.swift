//
//  HomeViewController.swift
//  FR SDK
//
//  Created by vahan.harutyunyan  on 1/4/22.
//

import Foundation
import UIKit
import FRAuth

class HomeViewController: UIViewController {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup and initialize FR SDK
        FRLog.setLogLevel([.network, .all])
        do {
            try FRAuth.start()
            print("SDK initialized successfully")
            updateStatus("SDK ready")
        }
        catch {
            print(error)
        }
        
        //check for existing user
        if FRUser.currentUser != nil {
            updateUI(loggedIn: true)
            updateStatus("Logged in user detected")
        } else {
            updateUI(loggedIn: false)
            updateStatus("Please log in")
        }
        
        navigationItem.title = "Forge Rock"
    }
    
    @IBAction func actionButtontapped(_ sender: UIButton) {
        if FRUser.currentUser == nil {
            pushLoginVC()
        } else {
            FRUser.currentUser?.logout()
            updateUI(loggedIn: false)
            updateStatus("Logged out")
        }
    }
    
    private func updateUI(loggedIn: Bool) {
        DispatchQueue.main.async {
            self.actionButton.setTitle(loggedIn ? "Logout" : "Login", for: .normal)
        }
    }
    
    private func updateStatus(_ status: String) {
        DispatchQueue.main.async {
            self.statusLabel.text = status
        }
    }
    
    private func pushLoginVC() {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
