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

class NodeViewController: UIViewController, StatusUpdatable, ViewControllerPushing {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var actionButton: UIButton!
    
    var inputDictionary = [String?: UIControl]()
    var node: Node?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        navigationItem.title = "Login"
        
        setupUI()
    }
    
    @IBAction func actionButtonClicked(_ sender: UIButton) {
        
        if let node = node {
            for callback in node.callbacks {
                if callback.isKind(of: SingleValueCallback.self), let singleValueCallback = callback as? SingleValueCallback {
                    if let textField = inputDictionary[singleValueCallback.inputName] as? UITextField {
                        singleValueCallback.setValue(textField.text)
                    }
                }
                
                if callback.isKind(of: ChoiceCallback.self), let choiceCallback = callback as? ChoiceCallback {
                    if let segmentedControl = inputDictionary[choiceCallback.inputName] as? UISegmentedControl {
                        choiceCallback.setValue(segmentedControl.selectedSegmentIndex)
                    }
                }
            }
            
            node.next(completion: {(token: Token?, node, error) in
                if let error = error {
                    print(error.localizedDescription)
                    self.updateStatus(error.localizedDescription, type: .error)
                } else if token != nil {
                    self.updateStatus("Login Success", type: .success)
                    self.pushUserInfoVC()
                } else if let node = node {
                    self.pushNodeVC(node)
                }
            })
        }
    }
    
    private func setupUI() {
        if let node = node {
            for callback in node.callbacks {
                if callback.isKind(of: NameCallback.self), let nameCallBack = callback as? NameCallback {
                    self.containerStackView.addArrangedSubview(makeUILabel(title: nameCallBack.prompt))
                    let textField = makeUITextField(isSecure: false)
                    self.containerStackView.addArrangedSubview(textField)
                    inputDictionary[nameCallBack.inputName] = textField
                }
                
                if callback.isKind(of: PasswordCallback.self), let passwordCallback = callback as? PasswordCallback {
                    self.containerStackView.addArrangedSubview(makeUILabel(title: passwordCallback.prompt))
                    let textField = makeUITextField(isSecure: true)
                    self.containerStackView.addArrangedSubview(textField)
                    inputDictionary[passwordCallback.inputName] = textField
                }
                
                if callback.isKind(of: ChoiceCallback.self), let choiceCallback = callback as? ChoiceCallback {
                    self.containerStackView.addArrangedSubview(makeUILabel(title: choiceCallback.prompt))
                    let segmentedControl = makeUISegmentedControl(segments: choiceCallback.choices, selectedIndex: choiceCallback.defaultChoice)
                    self.containerStackView.addArrangedSubview(segmentedControl)
                    inputDictionary[choiceCallback.inputName] = segmentedControl
                }
            }
        }
    }
    
}

extension NodeViewController {
    private func makeUILabel(title: String?) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textAlignment = .left
        label.textColor = .systemIndigo
        return label
    }
    
    private func makeUITextField(isSecure: Bool) -> UITextField {
        let textField = UITextField()
        textField.isSecureTextEntry = isSecure
        textField.textColor = .systemIndigo
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        return textField
    }
    
    private func makeUISegmentedControl(segments: [String], selectedIndex: Int) -> UISegmentedControl {
        let segmentedControl = UISegmentedControl(items: segments)
        segmentedControl.tintColor = .systemIndigo
        segmentedControl.selectedSegmentIndex = selectedIndex
        return segmentedControl
    }
    
}
