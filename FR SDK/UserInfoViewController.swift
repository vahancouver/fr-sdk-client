//
//  UserInfoViewController.swift
//  FR SDK
//
//  Created by vahan.harutyunyan  on 1/5/22.
//

import Foundation
import UIKit
import FRAuth

class UserInfoViewController: UIViewController, StatusUpdatable {
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var userInfoTextView: UITextView!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func loadView() {
        super.loadView()
        
        navigationItem.hidesBackButton = true
        navigationItem.title = "User Info"
        
        loadUserInfo()
    }
    
    @IBAction func logoutButtonClicked(_ sender: UIButton) {
        FRUser.currentUser?.logout()
        updateStatus("Logged out", type: .success)
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func loadUserInfo() {
        FRUser.currentUser?.getUserInfo(completion: { userInfo, error in
            if let error = error {
                self.updateUserInfo(error.localizedDescription)
            } else if let userInfo = userInfo {
                var desc = ""
                if let name = userInfo.name {
                    desc += "Name: " + name
                }
                if let preferredUsername = userInfo.preferredUsername {
                    desc += "\nPreferred Username: " + preferredUsername
                }
                if let sub = userInfo.sub {
                    desc += "\nSub: " + sub
                }
                if let email = userInfo.email {
                    desc += "\nEmail: " + email
                }
                if let phoneNumber = userInfo.phoneNumber {
                    desc += "\nPhone Number: " + phoneNumber
                }
                if let birthDate = userInfo.birthDate {
                    desc += "\nBirth Date: " + String(describing: birthDate)
                }
                
                self.updateUserInfo(desc)
            }
        })
    }
    
    private func updateUserInfo(_ userInfo: String) {
        DispatchQueue.main.async {
            self.userInfoTextView.text = userInfo
        }
    }
}

