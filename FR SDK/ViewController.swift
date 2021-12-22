//
//  ViewController.swift
//  FR SDK
//
//  Created by vahan.harutyunyan  on 12/21/21.
//

/**
 QUESTIONS:
 
 1. FRSession.currentSession is often nil after loggin in?
 
 
 2. After I login and logout one time, It returns access token even with invalid credentials..? and after that THINGS GO CRAZY
 */

import UIKit
import FRAuth

class ViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passswordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
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
        
        //check for existing session
        if FRSession.currentSession != nil {
            updateUI(loggedIn: true)
            updateStatus("Current session detected")
        } else {
            updateUI(loggedIn: false)
            updateStatus("Please log in")
        }
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        let username = usernameTextField.text
        let password = passswordTextField.text
        
        FRSession.authenticate(authIndexValue: "UsernamePassword") { result, node, error in
            if error != nil {
                print(error.debugDescription)
                self.updateStatus("Authentication Error")
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
                    }
                })
            }
        }
        
    }
    
    @IBAction func logoutButtonClicked(_ sender: UIButton) {
        FRSession.currentSession?.logout()
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
            
            if !loggedIn {
                self.usernameTextField.text = ""
                self.passswordTextField.text = ""
            }
        }
    }
    
}

