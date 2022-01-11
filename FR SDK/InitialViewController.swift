//
//  InitialViewController.swift
//  FR SDK
//
//  Created by vahan.harutyunyan  on 1/10/22.
//

import UIKit
import FRAuth

class InitialViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView?.tintColor = .systemIndigo
    }
    
    @IBAction func enbeddedLoginTapped(_ sender: UIButton) {
        pushEmbeddedLoginVC()
    }
    
    @IBAction func centralizedLoginTapped(_ sender: UIButton) {
        pushCentralizedLoginVC()
    }
    
    private func pushEmbeddedLoginVC() {
        DispatchQueue.main.async {
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EmbeddedLoginViewController") as? EmbeddedLoginViewController {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    private func pushCentralizedLoginVC() {
        DispatchQueue.main.async {
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CentralizedLoginViewController") as? CentralizedLoginViewController {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
}
