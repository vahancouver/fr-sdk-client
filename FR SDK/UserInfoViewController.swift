//
//  UserInfoViewController.swift
//  FR SDK
//
//  Created by vahan.harutyunyan  on 1/5/22.
//

import Foundation
import UIKit
import FRAuth

class UserInfoViewController: UIViewController {
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var userInfoTextView: UITextView!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func loadView() {
        super.loadView()
        navigationItem.hidesBackButton = true
        loadUserInfo()
    }
    
    @IBAction func logoutButtonClicked(_ sender: UIButton) {
        FRUser.currentUser?.logout()
        updateStatus("Logged out")
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func updateStatus(_ status: String) {
        DispatchQueue.main.async {
            self.statusLabel.text = status
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
