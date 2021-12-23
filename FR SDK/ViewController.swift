//
//  ViewController.swift
//  FR SDK
//
//  Created by vahan.harutyunyan  on 12/21/21.
//

/**
 QUESTIONS:
 
 */

import UIKit
import FRAuth

class ViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passswordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var userInfoTextView: UITextView!
    @IBOutlet weak var statusLabel: UILabel!
    
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
            loadUserInfo()
        } else {
            updateUI(loggedIn: false)
            updateStatus("Please log in")
        }
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        let username = usernameTextField.text
        let password = passswordTextField.text
        
        FRUser.login() { user, node, error in
            if error != nil {
                print(error.debugDescription)
                self.updateStatus("Authentication Error")
            } else if user != nil {
                self.updateStatus("Login Success:")
            }
            
            if let node = node {
                for callback in node.callbacks {
                    if callback.isKind(of: NameCallback.self), let nameCallBack = callback as? NameCallback {
                        nameCallBack.setValue(username)
                    }
                    
                    if callback.isKind(of: PasswordCallback.self), let passwordCallback = callback as? PasswordCallback {
                        passwordCallback.setValue(password)
                    }
                }
                
                node.next(completion: {(token: Token?, node, error) in
                    if error != nil {
                        print(error.debugDescription)
                        self.updateStatus("Login Failure")
                    }
                    
                    if token != nil {
                        self.updateStatus("Login Success")
                        self.updateUI(loggedIn: true)
                        self.loadUserInfo()
                    }
                })
            }
        }
    }
    
    @IBAction func logoutButtonClicked(_ sender: UIButton) {
        FRUser.currentUser?.logout()
        updateUI(loggedIn: false)
        updateStatus("Logged out")
    }
    
    private func updateStatus(_ status: String) {
        DispatchQueue.main.async {
            self.statusLabel.text = status
        }
    }
    
    private func updateUI(loggedIn: Bool) {
        DispatchQueue.main.async {
            self.loginButton.isEnabled = !loggedIn
            self.logoutButton.isEnabled = loggedIn
            self.usernameTextField.isEnabled = !loggedIn
            self.passswordTextField.isEnabled = !loggedIn
            self.userInfoTextView.isHidden = !loggedIn
            
            if !loggedIn {
                self.usernameTextField.text = ""
                self.passswordTextField.text = ""
            }
        }
    }
    
    private func loadUserInfo() {
        FRUser.currentUser?.getUserInfo(completion: { userInfo, error in
            if let error = error {
                self.updateUserInfo(error.localizedDescription)
            } else if let userInfo = userInfo {
                self.updateUserInfo(userInfo.debugDescription)
            }
        })
    }
    
    private func updateUserInfo(_ userInfo: String) {
        DispatchQueue.main.async {
            self.userInfoTextView.text = userInfo
        }
    }
    
}

