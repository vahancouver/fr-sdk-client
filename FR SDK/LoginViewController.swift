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

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passswordTextField: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func actionButtonClicked(_ sender: UIButton) {
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
                        self.pushUserInfoVC()
                    }
                })
            }
        }
    }
    
    private func updateStatus(_ status: String) {
        DispatchQueue.main.async {
            self.statusLabel.text = status
        }
    }
    
    private func pushUserInfoVC() {
        DispatchQueue.main.async {
            let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserInfoViewController") as UIViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
}
