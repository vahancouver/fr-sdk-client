//
//  Protocols.swift
//  FR SDK
//
//  Created by vahan.harutyunyan  on 1/7/22.
//

import UIKit
import FRAuth

// MARK: -  StatusUpdatable
enum StatusType {
    case error
    case info
    case success
}

protocol StatusUpdatable {
    var statusLabel: UILabel! { get set }
    func updateStatus(_ status: String, type: StatusType)
    
}

extension StatusUpdatable {
    func updateStatus(_ status: String, type: StatusType) {
        DispatchQueue.main.async {
            self.statusLabel.text = status
            switch type {
            case .error:
                self.statusLabel.textColor = .systemRed
            case .info:
                self.statusLabel.textColor = .systemOrange
            case .success:
                self.statusLabel.textColor = .systemGreen
            }
        }
    }
}

// MARK: - ViewControllerPushing

protocol ViewControllerPushing where Self: UIViewController {
    func pushUserInfoVC()
    func pushNodeVC(_ node: Node)
}

extension ViewControllerPushing {
    func pushUserInfoVC() {
        DispatchQueue.main.async {
            let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserInfoViewController") as UIViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func pushNodeVC(_ node: Node) {
        DispatchQueue.main.async {
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NodeViewController") as? NodeViewController {
                viewController.node = node
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}



