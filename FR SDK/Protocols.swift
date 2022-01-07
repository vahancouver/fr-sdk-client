//
//  Protocols.swift
//  FR SDK
//
//  Created by vahan.harutyunyan  on 1/7/22.
//

import UIKit

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

